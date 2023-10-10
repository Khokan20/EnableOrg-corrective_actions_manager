import 'package:enableorg/models/user.dart';
import 'package:enableorg/pages/manager/manager_pulse_questionnaire_page.dart';
import 'package:enableorg/ui/customTexts.dart';
import 'package:flutter/material.dart';

class ManagerPulseQuestionnaireNotificationsPage extends StatefulWidget {
  final User user;
  ManagerPulseQuestionnaireNotificationsPage({required this.user});
  @override
  State createState() => _ManagerPulseQuestionnaireNotificationsPageState();
}

class _ManagerPulseQuestionnaireNotificationsPageState
    extends State<ManagerPulseQuestionnaireNotificationsPage> {
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
            child: ManagerPulseQuestionnaireNotification(
              user: widget.user,
            ),
          ),
        ],
      ),
    );
  }
}
