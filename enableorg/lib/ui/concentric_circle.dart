import 'dart:math';

import 'package:enableorg/dto/colour_level_DTO.dart';
import 'package:flutter/material.dart';

import 'circle_config.dart';
import 'concentric_circle_painter.dart';
import 'customTexts.dart';

class ConcentricCircles extends StatelessWidget {
  final CircleConfig config;
  final double? width;
  final double? height;
  final String? label;
  final GroupsByColourAndLevelDTO coloursPerLevel;

  const ConcentricCircles(
      {required this.config,
      required this.width,
      required this.height,
      required this.label,
      required this.coloursPerLevel});

  @override
  Widget build(BuildContext context) {
    List<int> values = [];
    List<int> groupMapping = [];
    for (var group in config.groups) {
      values.addAll(group.values);
      groupMapping.addAll(List<int>.generate(
          group.values.length, (index) => group.name.hashCode));
    }

    final circleConfig = CircleConfig(groups: config.groups);

    return Column(
      children: [
        Text(
          label!, // Replace with your desired label
          style: CustomTextStyles.generalHeaderText,
        ),
        SizedBox(height: 1 / 5 * height!),
        Center(
          child: SizedBox(
            width: (max(width! - 150, 150)),
            height: (max(height! - 150, 150)),
            child: CustomPaint(
              painter: ConcentricCirclesPainter(
                colourPerLevel: coloursPerLevel,
                config: circleConfig,
                values: values,
                groupMapping: groupMapping,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
