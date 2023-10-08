import 'package:enableorg/ui/customTexts.dart';
import 'package:flutter/material.dart';

import '../../controller/user/user_profile_page_controller.dart';
import '../../dto/user_profile_image_DTO.dart';
import '../../models/user.dart';
import '../../widgets/user/user_profile_calender.dart';

class UserProfilePage extends StatelessWidget {
  final User user;
  UserProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    final UserProfilePageController userProfilePageController =
        UserProfilePageController();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: CustomTextStyles.generalHeaderText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  flex: 2,
                  child: UserProfileCalendar(
                    user: user,
                    getCircleColor: userProfilePageController.getCircleColor,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  flex: 1,
                  child: FutureBuilder<UserProfileImageDTO?>(
                    future:
                        userProfilePageController.getUserMedalImage(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error);
                      } else {
                        final UserProfileImageDTO? userProfileImage =
                            snapshot.data;
                        return Column(
                          children: [
                            Image.asset(
                              userProfileImage!.filepath,
                              height: screenHeight * 0.5,
                              width: screenWidth *
                                  0.6, // Adjust the width as needed
                            ),
                            Text(userProfileImage.text,
                                style: CustomTextStyles.medalText),
                          ],
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
