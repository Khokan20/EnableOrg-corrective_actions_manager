import 'package:enableorg/dto/completion_progress_DTO.dart';
import 'package:enableorg/dto/time_result_types.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/ui/custom_button.dart';
import 'package:enableorg/ui/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ui/custom_linear_progression.dart';

class ManagerCurrentQuestionnaire extends StatefulWidget {
  final Future<DateTime?> Function(String) expiryDate;
  final Future<CompleteProgressDTO> Function(ResultType, User)
      getCompletionProgress;
  final User user;
  final Future<bool> Function(User) onSendRemind;
  ManagerCurrentQuestionnaire(
      {required this.getCompletionProgress,
      required this.user,
      required this.onSendRemind,
      required this.expiryDate});

  @override
  // ignore: library_private_types_in_public_api
  _ManagerFbCurrentQuestionnaireState createState() =>
      _ManagerFbCurrentQuestionnaireState();
}

class _ManagerFbCurrentQuestionnaireState
    extends State<ManagerCurrentQuestionnaire> {
  DateTime? _expiry_date;
  String? _expiry_date_string;
  ResultType _selectedResultType = ResultType.latest;
  int _completionProgress = 0;
  int _totalCompletion = 0;
  double _totalCompletionVal = 0;

  @override
  void initState() {
    super.initState();
    _updateCompletionProgress();
  }

  Future<void> _updateCompletionProgress() async {
    CompleteProgressDTO progress =
        await widget.getCompletionProgress(_selectedResultType, widget.user);
    _expiry_date = await widget.expiryDate(widget.user.uid);
    if (_expiry_date != null) {
      // Format the date using DateFormat
      _expiry_date_string = DateFormat('dd/MM/yyyy').format(_expiry_date!);
    }
    setState(() {
      _completionProgress = progress.completed;
      _totalCompletion = progress.total;
      if (_totalCompletion == 0) {
        _totalCompletionVal = 1;
      } else {
        _totalCompletionVal = _completionProgress / _totalCompletion;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.0),
        _expiry_date != null
            ? Text('Current Questionnaire Expires on\n $_expiry_date_string',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Cormorant Garamond',
                  fontWeight: FontWeight.w400,
                ))
            : SizedBox(), // Placeholder if _expiry_date is null
        SizedBox(
          width: 180.0, // Set the width to 180
          height: 36.0, // Set the height to 36
          child: Align(
            alignment: Alignment.centerLeft, // Align the dropdown to the left
            child: SingleChildScrollView( // Wrap the dropdown with SingleChildScrollView
              child: CustomDropdown<ResultType>(
                value: _selectedResultType,
                onChanged: (value) {
                  setState(() {
                    _selectedResultType = value!;
                    _updateCompletionProgress();
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: ResultType.latest,
                    child: Text('Latest'),
                  ),
                  DropdownMenuItem(
                    value: ResultType.sixMonthsAgo,
                    child: Text('6 months ago'),
                  ),
                  DropdownMenuItem(
                    value: ResultType.oneYearAgo,
                    child: Text('12 months ago'),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        CustomLinearProgressIndicator(
          value: _totalCompletionVal,
          outlineColor: Colors.grey, // Replace with your value
          startColor: Colors.red[700]!, // Dark red
          endColor: Colors.green[700]!, // Dark green
        ),
        SizedBox(height: 16.0),
        Text(
            'Completion Progress: $_completionProgress out of $_totalCompletion'),
        SizedBox(height: 16.0), // Add some space before the button
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 180.0,
            height: 36.0,
            child: CustomButton(
                text: Text(
                  'Send Notification',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Cormorant Garamond',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onPressed: () {
                  widget.onSendRemind(widget.user);
                }),
          ),
        ),
      ],
    );
  }
}
