import 'package:enableorg/models/user.dart';
import 'package:enableorg/pages/manager/manager_foundation_questionnaire_page.dart';
import 'package:flutter/material.dart';

class ManagerQuestionnaireNotificationsPage extends StatefulWidget {
  final User user;
  ManagerQuestionnaireNotificationsPage({required this.user});
  @override
  State createState() => _ManagerQuestionnaireNotificationsPageState();
}

class _ManagerQuestionnaireNotificationsPageState
    extends State<ManagerQuestionnaireNotificationsPage> {
  // Initialize your questionnaire notification controller
  // For example: late ManagerQuestionnaireNotificationsController questionnaireNotificationsController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    // For example: questionnaireNotificationsController = ManagerQuestionnaireNotificationsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire Notifications'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Replace NewQuestionnaireNotificationForm with your actual widget
                // For example: NewQuestionnaireNotificationForm(
                //   getUsers: userAccountsController.getUsers,
                //   onNotificationSend: questionnaireNotificationsController.onNotificationSend,
                // ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: ManagerFoundationQuestionnaireNotification(
              user: widget.user,
            ),
          ),
        ],
      ),
    );
  }
}
