import 'package:enableorg/ui/customTexts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../dto/calendar_colours_DTO.dart';
import '../../models/user.dart';
import '../../ui/custom_calendar.dart';

class UserProfileCalendar extends StatefulWidget {
  final User user;
  final Future<CalendarColoursDTO> Function(String, DateTime) getCircleColor;

  UserProfileCalendar({required this.user, required this.getCircleColor});

  @override
  State<UserProfileCalendar> createState() => _UserProfileCalendarState();
}

class _UserProfileCalendarState extends State<UserProfileCalendar> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(screenHeight * 0.03),
      child: CustomTableCalendarHeader(
        onLeftChevronPressed: _previousMonth,
        onRightChevronPressed: _nextMonth,
        focusedDay: _selectedMonth,
        headerText: DateFormat.yMMMM().format(_selectedMonth),
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, date) {
            return DefaultTextStyle(
              style: CustomTextStyles.generalBodyText,
              textAlign: TextAlign.center,
              child: Text(
                DateFormat.yMMMM().format(date), // Display Month and Year
              ),
            );
          },
          prioritizedBuilder: (context, date, events) {
            if (date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday) {
              return SizedBox.shrink(); // Skip rendering for weekends
            } else {
              return FutureBuilder<CalendarColoursDTO?>(
                future: widget.getCircleColor(widget.user.uid, date),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Replace with a loading indicator
                  } else if (snapshot.hasError) {
                    return Icon(Icons.error); // Handle error
                  } else {
                    final CalendarColoursDTO? calendarColoursDTO =
                        snapshot.data;
                    return Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: calendarColoursDTO!.circleColour,
                          ),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontFamily: 'Cormorant Garamond',
                              fontSize: 15,
                              color: calendarColoursDTO.fontColour,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
