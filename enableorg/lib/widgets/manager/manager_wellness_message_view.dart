import 'package:enableorg/models/user.dart';
import 'package:enableorg/models/wellness_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageListView extends StatefulWidget {
  final Future<List<WellnessMessage>> Function(User) getAllMessages;
  final Future<void> Function(String) setRead;
  final User user;
  final Future<String> Function(String, bool) findSenderDisplayName;

  MessageListView(
      {required this.getAllMessages,
      required this.setRead,
      required this.user,
      required this.findSenderDisplayName});

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late Future<List<WellnessMessage>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    setState(() {
      _messagesFuture = widget.getAllMessages(widget.user);
    });
  }

  Future<void> _refreshMessages() async {
    setState(() {
      _messagesFuture = widget.getAllMessages(widget.user);
    });
  }

  void _showMessageDialog(WellnessMessage message) async {
    String sender = await widget.findSenderDisplayName(
        message.senderUID, message.isAnonymous);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context, // Use the local context variable
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${DateFormat.yMd().format(message.creationTimestamp.toDate())} ',
                  ),
                  Text('From: $sender'),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: Text(message.message),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.pop(
                //     dialogContext); // Use the local context variable here
                Navigator.of(context).pop();
                setState(() {
                  message.readStatus = true;
                  widget.setRead(message.wmid);
                });
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshMessages,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _loadMessages,
              child: Text('Reload'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<WellnessMessage>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading messages'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No messages found'),
                  );
                } else {
                  final messages = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Sender')),
                        DataColumn(label: Text('Message')),
                      ],
                      rows: messages.map((message) {
                        final truncatedMessage = message.message.length > 30
                            ? '${message.message.substring(0, 30)}...'
                            : message.message;
                        final rowColor = message.readStatus
                            ? null
                            : MaterialStateColor.resolveWith(
                                (states) => Colors.yellow);

                        return DataRow(
                          color: MaterialStateProperty.resolveWith(
                              (states) => rowColor),
                          cells: [
                            DataCell(
                              Text(
                                DateFormat.yMd()
                                    .format(message.creationTimestamp.toDate()),
                              ),
                            ),
                            DataCell(
                              FutureBuilder<String>(
                                future: widget.findSenderDisplayName(
                                  message.senderUID,
                                  message.isAnonymous,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error retrieving sender');
                                  } else {
                                    final senderName = snapshot.data!;
                                    return Text(senderName);
                                  }
                                },
                              ),
                            ),
                            DataCell(
                              GestureDetector(
                                onTap: () => _showMessageDialog(message),
                                child: Text(
                                  truncatedMessage,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontWeight: message.readStatus
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
