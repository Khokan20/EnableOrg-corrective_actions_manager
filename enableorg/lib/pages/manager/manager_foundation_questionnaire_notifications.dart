import 'package:enableorg/models/user.dart';
import 'package:enableorg/pages/manager/manager_foundation_questionnaire_page.dart';
import 'package:enableorg/ui/customTexts.dart';
import 'package:flutter/material.dart';

class ManagerFoundationQuestionnaireNotificationsPage extends StatefulWidget {
  final User user;
  ManagerFoundationQuestionnaireNotificationsPage({required this.user});
  @override
  State createState() => _ManagerFoundationQuestionnaireNotificationsPageState();
}

class _ManagerFoundationQuestionnaireNotificationsPageState
    extends State<ManagerFoundationQuestionnaireNotificationsPage> {
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
      body: Column(
        children: [
          SizedBox(height: 80.0), 
          Align(
            alignment: Alignment.centerLeft,// Add some space above the text
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Questionnaires',
              style: CustomTextStyles.generalHeaderText
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
