import 'package:enableorg/ui/customTexts.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomTableCalendarHeader extends StatelessWidget {
  final VoidCallback onLeftChevronPressed;
  final VoidCallback onRightChevronPressed;
  final String headerText;
  final CalendarBuilders calendarBuilders;
  final DateTime focusedDay; // Pass in the focusedDay

  CustomTableCalendarHeader({
    required this.onLeftChevronPressed,
    required this.onRightChevronPressed,
    required this.headerText,
    required this.calendarBuilders,
    required this.focusedDay, // Receive the focusedDay parameter
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onLeftChevronPressed,
              icon: Icon(Icons.chevron_left),
            ),
            Text(
              headerText,
              style: CustomTextStyles.boldedBodyText,
            ),
            IconButton(
              onPressed: onRightChevronPressed,
              icon: Icon(Icons.chevron_right),
            ),
          ],
        ),
        TableCalendar(
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle:
                TextStyle(color: Colors.transparent), // Hide weekend days
          ),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          availableCalendarFormats: {CalendarFormat.month: 'Month'},
          firstDay: DateTime.utc(2023, 1, 1),
          focusedDay: focusedDay, // Use the provided focusedDay
          rowHeight: 40,
          lastDay: DateTime.utc(2023, 12, 31),
          calendarBuilders: calendarBuilders,
          headerVisible: false,
        ),
      ],
    );
  }
}
