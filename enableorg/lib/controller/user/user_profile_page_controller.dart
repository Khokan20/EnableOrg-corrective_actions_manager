import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../dto/calendar_colours_DTO.dart';
import '../../dto/user_profile_image_DTO.dart';
import '../../models/wellness_message.dart';

class UserProfilePageController {
  Future<CalendarColoursDTO> getCircleColor(String uid, DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("WellnessMessage")
          .where('senderUID', isEqualTo: uid)
          .where('creationTimestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('creationTimestamp', isLessThan: Timestamp.fromDate(endDate))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        WellnessMessage wellnessMessage =
            WellnessMessage.fromDocumentSnapshot(querySnapshot.docs.first);

        // Map Wellness Message values to colors
        final Map<int, Color> colorMapping = {
          1: Colors.red,
          2: Colors.orange,
          3: Colors.yellow,
          4: Colors.lightGreen,
          5: Colors.green,
        };

        // Determine the color based on the Wellness Message value
        int value =
            wellnessMessage.value; // Replace with the actual value field
        Color circleColor = colorMapping[value] ?? Colors.transparent;

        // Determine font color based on circle color
        Color fontColor;
        if (circleColor == Colors.red) {
          fontColor = Colors.white;
        } else if (circleColor == Colors.transparent) {
          fontColor = Colors.black;
        } else {
          fontColor = Colors
              .black; // You can set different color based on your requirement
        }

        return CalendarColoursDTO(
          circleColour: circleColor,
          fontColour: fontColor,
        );
      } else {
        // Document doesn't exist, return transparent
        return CalendarColoursDTO(
          circleColour: Colors.transparent,
          fontColour: Colors.black,
        );
      }
    } catch (e) {
      print(e);
      // Return transparent and black font in case of error
      return CalendarColoursDTO(
        circleColour: Colors.transparent,
        fontColour: Colors.black,
      );
    }
  }

  Future<UserProfileImageDTO?> getUserMedalImage(String uid) async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime lastDate = currentDate
          .subtract(Duration(days: 1)); // Initialize with yesterday's date

      int consecutiveDays = 0;

      while (true) {
        CalendarColoursDTO colorsDTO = await getCircleColor(uid, lastDate);

        if (colorsDTO.circleColour != Colors.transparent) {
          consecutiveDays++;
          lastDate = lastDate.subtract(Duration(days: 1));
        } else {
          break;
        }
      }

      String medalImage;
      String text;

      if (consecutiveDays >= 48) {
        medalImage = 'hall_of_fame_medal';
        text = 'Hall of Fame\n 48 months';
      } else if (consecutiveDays >= 36) {
        medalImage = 'diamond_medal';
        text = 'Diamond\n 36 months';
      } else if (consecutiveDays >= 24) {
        medalImage = 'platinum_medal';
        text = 'Platinum\n 24 months';
      } else if (consecutiveDays >= 12) {
        medalImage = 'gold_medal';
        text = 'Gold\n 12 months';
      } else if (consecutiveDays >= 6) {
        medalImage = 'silver_medal';
        text = 'Silver\n 6 months';
      } else if (consecutiveDays >= 3) {
        medalImage = 'bronze_medal';
        text = 'Bronze\n 3 months';
      } else if (consecutiveDays >= 1) {
        medalImage = 'iron_medal';
        text = 'Iron\n 1 month';
      } else {
        medalImage = 'none_medal';
        text = 'Beginner\n 0 months';
      }

      medalImage += '-removebg-preview.png';

      // Simulate an async operation, replace with your actual logic
      await Future.delayed(Duration(seconds: 1));

      // Return the data with the appropriate medal image
      return UserProfileImageDTO(
        filepath: medalImage,
        text: text, // Update with appropriate text
      );
    } catch (e) {
      print(e);
      return null; // Return null in case of an error
    }
  }
}
