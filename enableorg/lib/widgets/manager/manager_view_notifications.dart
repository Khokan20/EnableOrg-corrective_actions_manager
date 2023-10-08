import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:enableorg/models/notification.dart' as model;

class ViewNotification extends StatelessWidget {
  final Future<List<model.Notification>> Function() getAllNotifications;

  ViewNotification({required this.getAllNotifications});

  void _showMessageDialog(
      BuildContext context, model.Notification notification) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Notification Details'),
        content: Text(notification.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<model.Notification>>(
      future: getAllNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading notifications'),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(
            child: Text('No notifications found'),
          );
        } else {
          final notifications = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Message')),
              ],
              rows: notifications.map((notification) {
                final truncatedMessage = notification.message.length > 15
                    ? '${notification.message.substring(0, 15)}...'
                    : notification.message;
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        DateFormat.yMd()
                            .format(notification.creationTimestamp.toDate()),
                      ),
                    ),
                    DataCell(
                      GestureDetector(
                        onTap: () => _showMessageDialog(context, notification),
                        child: Text(truncatedMessage),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
