import 'package:enableorg/controller/manager/manager_home_reports_controller.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/ui/circle_config.dart';
import 'package:enableorg/ui/concentric_circle.dart';
import 'package:enableorg/ui/customTexts.dart';
import 'package:enableorg/ui/custom_tab_bar.dart';
import 'package:enableorg/widgets/manager/manager_home_reports_filter.dart';
import 'package:flutter/material.dart';

import '../../dto/colour_level_DTO.dart';

class ManagerReportsHomePage extends StatefulWidget {
  final User user;

  ManagerReportsHomePage({required this.user});

  @override
  State createState() {
    return _ManagerReportsHomePageState();
  }
}

class _ManagerReportsHomePageState extends State<ManagerReportsHomePage> {
  late CircleConfig? circleConfigPRC = CircleConfig(groups: []);
  late CircleConfig? circleConfigWB = CircleConfig(groups: []);
  late CircleConfig? circleConfigPulse = CircleConfig(groups: []);
  final ManagerHomeReportsController managerHomePageController =
      ManagerHomeReportsController();
  final double circleHeight = 480;
  final double circleWidth = 480;
  final double smallScreenHeightSpacing = 150;
  final double bigScreenWidthSpacing = 150;
  final double headerSpacing = 60;
  final double scrollOffset = 120;
  final GroupsByColourAndLevelDTO coloursPerLevelPRC =
      GroupsByColourAndLevelDTO(coloursGroups: [
    ColourLevelListDTO(colourLevelList: [
      ColourLevelDTO(level: 1, color: Color(0xFF900604)),
      ColourLevelDTO(level: 2, color: Color(0xFF900604)),
      ColourLevelDTO(level: 3, color: Color(0xFFC00000)),
      ColourLevelDTO(level: 4, color: Color(0xFFFFC000)),
      ColourLevelDTO(level: 5, color: Color(0xFFFFFF00)),
    ])
  ]);

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
  final GroupsByColourAndLevelDTO coloursPerLevelPUL =
      GroupsByColourAndLevelDTO(
    coloursGroups: [
      // Group 1: Blue Gradient
      ColourLevelListDTO(
        colourLevelList: [
       ColourLevelDTO(level: 1, color: Color(0xFF0070C0)),
      ColourLevelDTO(level: 2, color: Color(0xFF0070C0)),
      ColourLevelDTO(level: 3, color: Color(0xFF0070C0)),
      ColourLevelDTO(level: 4, color: Color(0xFF002060)),
      ColourLevelDTO(level: 5, color: Color(0xFF002060)),
        ],
      ),
      // Group 2: Green Gradient
      ColourLevelListDTO(
        colourLevelList: [
         ColourLevelDTO(level: 1, color: Color(0xFF93D04F)),
      ColourLevelDTO(level: 2, color: Color(0xFF93D04F)),
      ColourLevelDTO(level: 3, color: Color(0xFF93D04F)),
      ColourLevelDTO(level: 4, color: Color(0xFF00B050)),
      ColourLevelDTO(level: 5, color: Color(0xFF00B050)),
        ],
      ),
      // Group 3: Red Gradient
      ColourLevelListDTO(
        colourLevelList: [
        ColourLevelDTO(level: 1, color: Color(0xFF900403)),
      ColourLevelDTO(level: 2, color: Color(0xFF900403)),
      ColourLevelDTO(level: 3, color: Color(0xFF900403)),
      ColourLevelDTO(level: 4, color: Color(0xFFC00000)),
      ColourLevelDTO(level: 5, color: Color(0xFFC00000)),
        ],
      ),
      // Group 4: Yellow/Orange Gradient
      ColourLevelListDTO(
        colourLevelList: [
        ColourLevelDTO(level: 1, color: Color(0xFFFFC000)),
      ColourLevelDTO(level: 2, color: Color(0xFFFFC000)),
      ColourLevelDTO(level: 3, color: Color(0xFFFFC000)),
      ColourLevelDTO(level: 4, color: Color(0xFFFFFF00)),
      ColourLevelDTO(level: 5, color: Color(0xFFFFFF00)),
        ],
      ),
      // Group 5: Cyan Gradient
      ColourLevelListDTO(
        colourLevelList: [
          ColourLevelDTO(level: 1, color: Color(0xFF01D29C)),
      ColourLevelDTO(level: 2, color: Color(0xFF01D29C)),
      ColourLevelDTO(level: 3, color: Color(0xFF01D29C)),
      ColourLevelDTO(level: 4, color: Color(0xFF009BA5)),
      ColourLevelDTO(level: 5, color: Color(0xFF009BA5)),
        ],
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _loadCircleConfig();

  }

  _loadCircleConfig() async {
    circleConfigPRC = (await managerHomePageController.getPRCConfig());
    circleConfigPulse = (await managerHomePageController.getPulseConfig());
    circleConfigWB = (await managerHomePageController.getWBConfig());
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    // padding: EdgeInsets.only(left: 105),
    return CustomTabulation(
      tabs: [
        'Foundation Climate', // First Tab
        'Pulse Climate', // Second Tab
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
                        if (circleConfigPRC != null)
                          SizedBox(
                            width: circleWidth,
                            height: circleHeight,
                            child: ConcentricCircles(
                              coloursPerLevel: coloursPerLevelPRC,
                              label: "Psychosocial Risk Climate",
                              config: circleConfigPRC!,
                              width: circleWidth,
                              height: circleHeight,
                            ),
                          ),
                        if (circleConfigPRC != null)
                          SizedBox(height: smallScreenHeightSpacing),
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
                            if (circleConfigPRC != null)
                              SizedBox(
                                width: circleWidth,
                                height: circleHeight,
                                child: ConcentricCircles(
                                  coloursPerLevel: coloursPerLevelPRC,
                                  label: "Psychological Risk Climate",
                                  config: circleConfigPRC!,
                                  height: circleHeight,
                                  width: circleWidth,
                                ),
                              ),
                            if (circleConfigPRC != null)
                              SizedBox(
                                  width:
                                      bigScreenWidthSpacing), // Add spacing between circles
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

        // Second Tab View
        SingleChildScrollView(
          child: Column(
            children: [
              // Your existing code for Pulse Climate here
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 15, left: 18),
                  child: Text(
                    'Reports',
                    style: CustomTextStyles.generalHeaderText,
                  ),
                ),
              ),
              SizedBox(height: headerSpacing), // Add spacing
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Switch to vertical layout if the screen width is less than 600
                    return Column(
                      children: [
                        if (circleConfigPulse != null)
                          SizedBox(
                            width: circleWidth,
                            height: circleHeight,
                            child: ConcentricCircles(
                              coloursPerLevel:
                                  coloursPerLevelPUL, // Adjust colors as needed
                              label: "Pulse Climate",
                              config:
                                  circleConfigPulse!, // Adjust configuration as needed
                              width: circleWidth,
                              height: circleHeight,
                            ),
                        ),
                        SizedBox(height: smallScreenHeightSpacing),
                        // Add more widgets as needed for Pulse Climate
                        SizedBox(height: scrollOffset),
                      ],
                    );
                  } else {
                    // Use horizontal layout for larger screens
                    return Column(
                      children: [
                        Column(children: [
                          if (circleConfigPulse != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: circleWidth,
                                  height: circleHeight,
                                  child: ConcentricCircles(
                                    coloursPerLevel:
                                        coloursPerLevelPUL, // Adjust colors as needed
                                    label: "Pulse Climate",
                                    config:
                                        circleConfigPulse!, // Adjust configuration as needed
                                    height: circleHeight,
                                    width: circleWidth,
                                  ),
                                ),
                              // Add more widgets as needed for Pulse Climate
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: smallScreenHeightSpacing,
                        ),
                        // Add more widgets as needed for Pulse Climate
                      ],
                    );
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
