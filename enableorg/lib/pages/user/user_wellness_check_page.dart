import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/models/wellness_message.dart';
import 'package:enableorg/controller/user/user_wellness_check_controller.dart';
import 'package:random_string/random_string.dart';

class UserWellnessCheckPage extends StatefulWidget {
  final User user;

  UserWellnessCheckPage({required this.user});

  @override
  State<UserWellnessCheckPage> createState() => _UserWellnessCheckPageState();
}

class _UserWellnessCheckPageState extends State<UserWellnessCheckPage> {
  late UserWellnessCheckController _controller;
  int _sliderValue = 3;
  bool _shareAnonymously = false;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = UserWellnessCheckController();
  }

  Future<void> _showSubmissionDialog(Future<String> message) async {
    final result = await message;
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submission'),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wellness Check Page'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('How was your day overall?'),
              ),
              Slider(
                value: _sliderValue.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value.toInt();
                  });
                },
                activeColor: _getColorForSliderValue(_sliderValue),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Tell us about it',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Write your message...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _shareAnonymously,
                      onChanged: (value) {
                        setState(() {
                          _shareAnonymously = value ?? false;
                        });
                      },
                    ),
                    Text('Share Anonymously'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final message = _messageController.text;
                    final senderUID = widget.user.uid;

                    Future<String> title = _controller.onSendMessage(
                      widget.user,
                      WellnessMessage(
                        value: _sliderValue,
                        message: message,
                        senderUID: senderUID,
                        recipientUID: widget.user.managerId,
                        creationTimestamp: Timestamp.now(),
                        readStatus: false,
                        isAnonymous: _shareAnonymously,
                        wmid: randomAlphaNumeric(30),
                      ),
                    );

                    await _showSubmissionDialog(title);
                  },
                  child: Text('Send Message'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForSliderValue(int value) {
    switch (value) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
