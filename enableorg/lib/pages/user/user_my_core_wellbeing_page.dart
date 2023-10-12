import 'package:enableorg/controller/user/user_my_core_wellbeing_controller.dart';
import 'package:enableorg/ui/circle_config.dart';
import 'package:enableorg/ui/concentric_circle.dart';
import 'package:enableorg/ui/custom_tab_bar.dart';
import 'package:enableorg/widgets/manager/manager_home_reports_filter.dart';
import 'package:flutter/material.dart';

import '../../dto/colour_level_DTO.dart';
import '../../models/user.dart';

class UserMyCoreWellbeingPage extends StatefulWidget {
  final User user;
  UserMyCoreWellbeingPage({required this.user});

  @override
  State createState() {
    return _UserMyCoreWellbeingPageState();
  }
}

class _UserMyCoreWellbeingPageState extends State<UserMyCoreWellbeingPage> {
  late CircleConfig? circleConfigWB = CircleConfig(groups: []);
  late UserMyCoreWellbeingController userMyCoreWellbeingController;
  final double circleHeight = 480;
  final double circleWidth = 480;
  final double smallScreenHeightSpacing = 150;
  final double bigScreenWidthSpacing = 150;
  final double headerSpacing = 60;
  final double scrollOffset = 120;

  final GroupsByColourAndLevelDTO coloursPerLevelWB =
      GroupsByColourAndLevelDTO(coloursGroups: [
    ColourLevelListDTO(colourLevelList: [
      ColourLevelDTO(level: 1, color: Color(0xFF93D04F)),
      ColourLevelDTO(level: 2, color: Color(0xFF01D29C)),
      ColourLevelDTO(level: 3, color: Color(0xFF009BA5)),
      ColourLevelDTO(level: 4, color: Color(0xFF0070C0)),
      ColourLevelDTO(level: 5, color: Color(0xFF002060)),
    ])
  ]);

  @override
  void initState() {
    super.initState();
    userMyCoreWellbeingController =
        UserMyCoreWellbeingController(user: widget.user);
    _loadCircleConfig();
  }

  _loadCircleConfig() async {
    circleConfigWB = (await userMyCoreWellbeingController.getWBConfig());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    // padding: EdgeInsets.only(left: 105),
    return CustomTabulation(
      tabs: [
        'My Core Wellbeing', // First Tab
      ],
      tabContent: [
        // First Tab View
        SingleChildScrollView(
          child: Column(
            children: [
              // Your existing code for Foundation Climate here
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 15, left: 18),
                    child: HomeReportsFilter()),
              ),
              SizedBox(height: headerSpacing), // Add spacing
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    // Switch to vertical layout if the screen width is less than 600
                    return Column(
                      children: [
                        if (circleConfigWB != null)
                          SizedBox(
                            width: circleWidth,
                            height: circleHeight,
                            child: ConcentricCircles(
                              coloursPerLevel: coloursPerLevelWB,
                              label: "Core Wellbeing Climate",
                              config: circleConfigWB!,
                              width: circleWidth,
                              height: circleHeight,
                            ),
                          ),
                        if (circleConfigWB != null)
                          SizedBox(height: scrollOffset),
                      ],
                    );
                  } else {
                    // Use horizontal layout for larger screens
                    return Column(children: [
                      Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (circleConfigWB != null)
                              SizedBox(
                                width: circleWidth,
                                height: circleHeight,
                                child: ConcentricCircles(
                                  coloursPerLevel: coloursPerLevelWB,
                                  label: "Core Wellbeing Climate",
                                  config: circleConfigWB!,
                                  height: circleHeight,
                                  width: circleWidth,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: scrollOffset),
                      ])
                    ]);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
