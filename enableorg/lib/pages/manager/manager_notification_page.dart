import 'package:enableorg/controller/manager/manager_notification_controller.dart';
import 'package:enableorg/controller/manager/manager_user_accounts_controller.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/widgets/manager/manager_new_notification.dart';
import 'package:enableorg/widgets/manager/manager_view_notifications.dart';
import 'package:flutter/material.dart';

class ManagerNotificationPage extends StatefulWidget {
  final User user;

  ManagerNotificationPage({required this.user});
  @override
  State<ManagerNotificationPage> createState() =>
      _ManagerNotificationPageState();
}

class _ManagerNotificationPageState extends State<ManagerNotificationPage> {
  late ManagerNotificationController notificationController;
  late ManagerUserAccountsController userAccountsController;

  @override
  void initState() {
    super.initState();
    notificationController = ManagerNotificationController();
    userAccountsController = ManagerUserAccountsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notifications'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: NewNotificationForm(
                  getUsers: userAccountsController.getUsers,
                  onNotificationSend: notificationController.onNotificationSend,
                  user: widget.user,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: ViewNotification(
              getAllNotifications: notificationController.getAllNotifications,
            ),
          ),
        ],
      ),
    );
  }
}
