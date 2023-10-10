import 'package:enableorg/controller/user/foundation_builder_controller.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/pages/user/foundation_builder_page.dart';
import 'package:enableorg/pages/user/user_my_core_wellbeing_page.dart';
import 'package:enableorg/pages/user/user_profile_page.dart';
import 'package:enableorg/pages/user/wellness_builder_page.dart';
import 'package:enableorg/pages/user/user_wellness_check_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserHomePage extends StatefulWidget {
  final User user;

  UserHomePage({required this.user});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int currentIndex = 0; // Start with Foundation Questions page
  bool showAlert = false;

  void navigateToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<void> _checkConditionForAlert() async {
    FoundationBuilderController fbController =
        FoundationBuilderController(currentUser: widget.user);

    bool reminderCheck = await fbController.checkFBRemind(widget.user);
    print("Remind alert is $reminderCheck");
    setState(() {
      showAlert = reminderCheck; // Replace with your actual condition
    });
  }

  @override
  void initState() {
    super.initState();
    _checkConditionForAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 300,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Center(
                  child: Image.asset(
                    "UserLogo_trans.png",
                    height: 126, // Increase the height of the logo
                  ),
                ),
                SizedBox(height: 24),
                // Toggle button for Foundation Questions
                InkWell(
                  onTap: () => navigateToPage(0),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'Foundation Builder',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 0 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8),
                // Toggle button for Wellness Questions
                InkWell(
                  onTap: () => navigateToPage(1),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'Wellness Builder',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 0 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8),
                InkWell(
                  onTap: () => navigateToPage(2),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'Wellness Check',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 0 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                InkWell(
                  onTap: () => navigateToPage(0),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'Assigned Actions',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 0 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Toggle button for Wellness Check
                InkWell(
                  onTap: () => navigateToPage(3),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 1 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => navigateToPage(4),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'My Core WellBeing',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 0 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Toggle button for Wellness Check
                InkWell(
                  onTap: () => navigateToPage(1),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'My Wellbeing Plan',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 1 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => navigateToPage(1),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      'My Work',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontSize: 16,
                        color:
                            currentIndex == 1 ? Color(0xFF161D58) : Colors.grey,
                      ),
                    ),
                  ),
                ),
                Spacer(),

                // User's name display
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ' ${widget.user.name}', // Assuming the User class has a 'name' property
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      fontSize: 20,
                      color: Color(0xFF161D58),
                    ),
                  ),
                ),

                SizedBox(height: 8),
                InkWell(
                  onTap: logout, // Implement your logout function
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.password), // password icon
                        SizedBox(width: 8),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            fontFamily: 'Cormorant Garamond',
                            fontSize: 14,
                            color: Color(0xFF161D58),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Logout button
                InkWell(
                  onTap: logout, // Implement your logout function
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
                            fontSize: 14,
                            color: Color(0xFF161D58),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '© 2023 EnableOrg', // Replace 'Your Company Name' with your actual company name
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      fontSize: 14,
                      color: Color(0xFF161D58),
                    ),
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          ),

          // Add a vertical divider similar to the ManagerHomePage

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
                FoundationBuilderPage(user: widget.user),
                WellnessBuilderPage(user: widget.user),
                UserWellnessCheckPage(user: widget.user),
                UserProfilePage(user: widget.user),
                UserMyCoreWellbeingPage(user: widget.user),
                // Add other destination widgets as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  void logout() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/user/login');
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
}
