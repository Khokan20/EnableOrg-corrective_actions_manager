import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/user.dart';
import 'package:flutter/material.dart';
import 'package:enableorg/models/notification.dart' as model;
import 'package:multi_select_flutter/multi_select_flutter.dart';

class NewNotificationForm extends StatefulWidget {
  final Future<List<User>> Function(BuildContext, String) getUsers;
  final void Function(model.Notification)
      onNotificationSend; // New callback function
  final User user;

  NewNotificationForm(
      {required this.getUsers,
      required this.onNotificationSend,
      required this.user // Include the new callback function
      });

  @override
  State<NewNotificationForm> createState() => _NewNotificationFormState();
}

class _NewNotificationFormState extends State<NewNotificationForm> {
  late String _title;
  late String _body;
  List<String> _selectedRecipients = [];
  late List<User> _users; // New variable to store the list of users

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    _users = await widget.getUsers(context, ''); // Await the getUsers function
    setState(() {
      // Trigger a rebuild after fetching the users
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (outercontext) => AlertDialog(
            title: Text('New Notification'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Message'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a message';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _body = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  MultiSelectDialogField<String>(
                    items: _users
                        .map((user) =>
                            MultiSelectItem<String>(user.uid, user.email))
                        .toList(),
                    initialValue: _selectedRecipients,
                    onConfirm: (values) {
                      setState(() {
                        _selectedRecipients = values;
                      });
                    },
                    title: Text('Recipients'),
                    confirmText: Text(
                      'Okay',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF161D58),
                      ),
                    ),
                    cancelText: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF161D58),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final notification = model.Notification(
                          title: _title,
                          message: _body,
                          senderUID:
                              '', // Replace with the ID of the logged-in user
                          recipientUID: _selectedRecipients,
                          creationTimestamp: Timestamp.now(),
                          nid:
                              '', // Generate or provide an appropriate ID for the notification
                        );

                        widget.onNotificationSend(notification);
                        Navigator.pop(outercontext); // Close the dialog
                      }
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text('+ New Notification'),
    );
  }
}
