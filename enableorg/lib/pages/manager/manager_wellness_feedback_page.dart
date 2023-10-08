import 'package:enableorg/controller/manager/manager_wellness_feeback_controller.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/widgets/manager/manager_wellness_message_view.dart';
import 'package:flutter/material.dart';

class ManagerWellnessFeedbackPage extends StatefulWidget {
  final User user;

  ManagerWellnessFeedbackPage({required this.user});
  @override
  State<ManagerWellnessFeedbackPage> createState() =>
      _WellnessFeedbackPageState();
}

class _WellnessFeedbackPageState extends State<ManagerWellnessFeedbackPage> {
  late ManagerWellnessFeedbackController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ManagerWellnessFeedbackController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness Feedback Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageListView(
              getAllMessages: _controller.getAllMessagesForManager,
              setRead: _controller.setRead,
              user: widget.user,
              findSenderDisplayName: _controller.findSenderDisplayName,
            ),
          ),
        ],
      ),
    );
  }
}
