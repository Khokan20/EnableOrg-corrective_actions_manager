import 'package:enableorg/models/user.dart';
import 'package:enableorg/pages/manager/manager_pulse_questionnaire_page.dart';
import 'package:enableorg/pages/manager/manager_questionnaire_notifications.dart';
import 'package:enableorg/pages/manager/manager_user_accounts_page.dart';
import 'package:enableorg/pages/manager/manager_wellness_feedback_page.dart';
import 'package:enableorg/pages/manager/manager_notification_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'manager_corrective_actions_page.dart';
import 'manager_reports_home_page.dart';

class ManagerHomePage extends StatefulWidget {
  final User user;

  ManagerHomePage({required this.user});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  int currentIndex = 0;

  void navigateToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void logout() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/manager/login');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Logout Error'),
          content: Text('Failed to log out. Please try again.'),
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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white, // Change the primary color
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme
              .primary, // Ensure the button text is styled correctly
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Cormorant Garamond',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF161D58),
          ),
        ),
      ),
      home: Scaffold(
        body: Row(
          children: [
            // First section for the logo and the toggles (left side)
            Container(
              width: 250, // Set the width for the navigation side
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  SizedBox(
                    height: 15,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Center(
                    child: Image.asset(
                      "managercons_transp.png",
                      height: 110, // Increase the height of the logo
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ), // Increase the spacing between the logo and toggle buttons

                  InkWell(
                    onTap: () => navigateToPage(0),
                    child: Row(
                      children: [
                        Icon(Icons.home), // home icon
                        SizedBox(width: 8),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF161D58),
                            fontFamily: 'Cormorant Garamond',
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  // Reports
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.auto_graph), // reports icon
                        SizedBox(width: 8),
                        Text(
                          'Reports',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF161D58),
                            fontFamily: 'Cormorant Garamond',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // Toggle button for Reports
                  InkWell(
                    onTap: () => navigateToPage(0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 42),
                      child: Text(
                        'Executive Summary',
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontSize: 12,
                          color: Color(0xFF161D58),
                        ),
                      ),
                    ),
                  ),
                  // Toggle button for Reports

                  // Toggle button for Reports
                  InkWell(
                    onTap: () => navigateToPage(5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 42),
                      child: Text(
                        'Corrective Actions',
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontSize: 12,
                          color: Color(0xFF161D58),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ), // Add some spacing between heading and toggle
                  // Questionnaires
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.check_box_outlined), // questionnaires icon
                        SizedBox(width: 8),
                        Text(
                          'Questionnaires',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF161D58),
                            fontFamily: 'Cormorant Garamond',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // Toggle button for Foundation Questionnaires
                  InkWell(
                    onTap: () => navigateToPage(1),
                    child: Padding(
                      padding: EdgeInsets.only(left: 42),
                      child: Text(
                        'Foundation Questionnaire',
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontSize: 12,
                          color: Color(0xFF161D58),
                        ),
                      ),
                    ),
                  ),
                  // Toggle button for Pulse Questionnaires
                  InkWell(
                    onTap: () => navigateToPage(6),
                    child: Padding(
                      padding: EdgeInsets.only(left: 42),
                      child: Text(
                        'Pulse Questionnaire',
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontSize: 12,
                          color: Color(0xFF161D58),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ), // Add spac
                  // Wellbeing Feedback (Toggle and Title)
                  InkWell(
                    onTap: () => navigateToPage(2),
                    child: Row(
                      children: [
                        Icon(Icons
                            .assignment_returned_outlined), // Wellness  icon
                        SizedBox(width: 8),
                        Text(
                          'Wellness Feedback',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF161D58),
                            fontFamily: 'Cormorant Garamond',
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ), // Add spacing between sections

                  // Manage Accounts
                  Row(
                    children: [
                      Icon(Icons.people), // Users icon
                      SizedBox(width: 8),
                      Text(
                        'Manage',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF161D58),
                          fontFamily: 'Cormorant Garamond',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ), // Add some spacing between heading and toggle

                  // Toggle buttons for User Accounts and Push Notifications
                  InkWell(
                    onTap: () => navigateToPage(3),
                    child: Padding(
                      padding: EdgeInsets.only(left: 42),
                      child: Text(
                        'User Accounts',
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF161D58),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => navigateToPage(4),
                    child: Padding(
                      padding: EdgeInsets.only(left: 42),
                      child: Text(
                        'Push Notifications',
                        style: TextStyle(
                          fontFamily: 'Cormorant Garamond',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF161D58),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ), // Add some spacing between heading and toggle

                  // Add space between the last toggle and the logout button
                  Spacer(),

                  // User's name display
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ' ${widget.user.name}', // Assuming the User class has a 'name' property
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color: Color(0xFF161D58),
                      ),
                    ),
                  ),

                  SizedBox(
                      height:
                          4), // Add spacing between user name and logout button
                  InkWell(
                    onTap: logout,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.password), // Logout icon
                          SizedBox(width: 8),
                          Text(
                            'Change Password',
                            style: TextStyle(
                              fontFamily: 'Cormorant Garamond',
                              fontSize: 12,
                              color: Color(0xFF161D58),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  // Logout button
                  InkWell(
                    onTap: logout,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app), // Logout icon
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Cormorant Garamond',
                              fontSize: 12,
                              color: Color(0xFF161D58),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                      height:
                          16), // Add spacing between user name and logout button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '© 2023 EnableOrg', // Replace 'Your Company Name' with your actual company name
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 12,
                        color: Color(0xFF161D58),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                ],
              ),
            ),

            // Add a line to separate the navigation side and the pages (vertical divider)
            Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[200]!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: -2,
                    blurRadius: 4,
                    offset: Offset(-2,
                        0), // Update the offset to change the shadow direction
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: VerticalDivider(
                color: Colors.transparent,
                thickness: 2,
                width: 1,
              ),
            ),

            // Second section with the pages (right side)
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: [
                  ManagerReportsHomePage(user: widget.user),
                  ManagerQuestionnaireNotificationsPage(user: widget.user),
                  ManagerWellnessFeedbackPage(user: widget.user),
                  ManagerUserAccountsPage(user: widget.user),
                  ManagerNotificationPage(
                    user: widget.user,
                  ),
                  ManagerCorrectiveActionsPage(user: widget.user),
                  ManagerPulseQuestionnaireNotification(user: widget.user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
