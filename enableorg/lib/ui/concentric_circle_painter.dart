import 'dart:math';

import 'package:enableorg/ui/customTexts.dart';
import 'package:flutter/material.dart';

import '../dto/colour_level_DTO.dart';
import 'circle_config.dart';

class ConcentricCirclesPainter extends CustomPainter {
  final CircleConfig config;
  final List<int> values;
  final List<int> groupMapping;
  final GroupsByColourAndLevelDTO colourPerLevel;

  int currentGroup = 0;
  List<int> groupsCount = [];

  int calculateNumSections(CircleConfig config) {
    int numSections = 0;
    for (var group in config.groups) {
      numSections += group.values.length;
      groupsCount.add(group.values.length);
    }
    return numSections;
  }

  int calculateNumGroups(CircleConfig config) {
    return config.groups.length;
  }

  List<String> extractNames(CircleConfig config) {
    List<String> names = [];
    for (var group in config.groups) {
      names.add(group.name);
    }
    return names;
  }

  ConcentricCirclesPainter(
      {required this.config,
      required this.values,
      required this.groupMapping,
      required this.colourPerLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    int numSections = 0;
    int numGroups = 0;
    numSections = calculateNumSections(config);
    numGroups = calculateNumGroups(config);
    double sectionAngle = 0;

    final names = extractNames(config);
    final radiusStep = radius / 5;

    sectionAngle = 2 * pi / numSections;

    final outerCirclePaint = Paint()
      ..color = _getValueColor(-1, -1) // Expecting default
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(centerX, centerY), radius, outerCirclePaint);
    final centerToEdgeLinePaintPerSection = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // This is for inner group dividers

    // print("$numGroups <- Number of groups");
    int valuesIndex = 0;
    // print(groupsCount);

    for (int group = 0; group < numGroups; group++) {
      for (int section = 0; section < groupsCount[group]; section++) {
        final startAngle = valuesIndex * sectionAngle;
        final endAngle = startAngle + sectionAngle;

        final sectionStartX = centerX + (radius) * cos(startAngle);
        final sectionStartY = centerY + (radius) * sin(startAngle);

        canvas.drawLine(
            Offset(centerX, centerY),
            Offset(sectionStartX, sectionStartY),
            centerToEdgeLinePaintPerSection);

        // Draw wider lines between valueames in the same group
        final lineWidth = values[section] == 1 ? 6.0 : 2.0;

        final outerCirclePaint = Paint()
          ..color = Colors.white // Border color
          ..style = PaintingStyle.stroke // Stroke style for the border
          ..strokeWidth = 1.0;
        // This is for inner group horizontal borders
        // print(
        //     'valueIndex: $valuesIndex group:$group
        // section: $section groupsCount[section]: ${groupsCount[group]}');
        for (int nextLevel = values[valuesIndex]; nextLevel >= 0; nextLevel--) {
          final arcPath = Path()
            ..moveTo(centerX, centerY)
            ..arcTo(
              Rect.fromCircle(
                center: Offset(centerX, centerY),
                radius: radiusStep * nextLevel,
              ),
              startAngle,
              sectionAngle,
              false,
            )
            ..arcTo(
              Rect.fromCircle(
                center: Offset(centerX, centerY),
                radius: radiusStep * (nextLevel - 1),
              ),
              endAngle,
              -sectionAngle,
              false,
            )
            ..close();

          // print('$nextLevel is currentLevel and group is $group');
          final paint = Paint()
            ..color = _getValueColor(nextLevel, group)
            ..style = PaintingStyle.fill
            ..strokeWidth = lineWidth;

          // Then draw the filled circle on top of it
          canvas.drawPath(arcPath, paint);
        }
        valuesIndex++;

        for (int nextLevel = 1; nextLevel <= 5; nextLevel++) {
          final arcPath = Path()
            ..moveTo(centerX, centerY)
            ..arcTo(
              Rect.fromCircle(
                center: Offset(centerX, centerY),
                radius: radiusStep * nextLevel,
              ),
              startAngle,
              sectionAngle,
              false,
            )
            ..arcTo(
              Rect.fromCircle(
                center: Offset(centerX, centerY),
                radius: radiusStep * (nextLevel - 1),
              ),
              endAngle,
              -sectionAngle,
              false,
            )
            ..close();

          // Draw the border first
          canvas.drawPath(arcPath, outerCirclePaint);
        }
      }
    }

    final centerToEdgeLinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0; // This is for outer group spacing
    final labelRadius = radius + 1.6 * radiusStep;

    int currentSection = 0;

    for (int group = 0; group < numGroups; group++) {
      final sectionStartAngle = currentSection * sectionAngle;

      final sectionStartX = centerX + radius * cos(sectionStartAngle);
      final sectionStartY = centerY + radius * sin(sectionStartAngle);

      canvas.drawLine(Offset(centerX, centerY),
          Offset(sectionStartX, sectionStartY), centerToEdgeLinePaint);

      currentSection += config.groups[group].numberOfValues;
    }

    currentSection = 0;

    for (int group = 0; group < numGroups; group++) {
      final sectionStartAngle = currentSection * sectionAngle;
      final sectionEndAngle =
          (currentSection + config.groups[group].numberOfValues) * sectionAngle;

      final groupCenterAngle = (sectionStartAngle + sectionEndAngle) / 2;
      final groupLabelX = centerX + labelRadius * cos(groupCenterAngle);
      final groupLabelY = centerY + labelRadius * sin(groupCenterAngle);
      final labelText = names[group];

      final labelPainter = TextPainter(
        text: TextSpan(
            text: labelText, style: CustomTextStyles.boldedReportsHeaderText),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2, // Maximum number of lines (adjust as needed)
        ellipsis: '...', // Text to show if the label is truncated (optional)
      );

      labelPainter.layout();

      canvas.save();

      canvas.translate(groupLabelX - labelPainter.width / 2,
          groupLabelY - labelPainter.height / 2);
      labelPainter.paint(canvas, Offset.zero);

      canvas.restore();

      currentSection += config.groups[group].numberOfValues;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Color _getValueColor(int level, int group) {
    Color getColor(int level, int group, {int alpha = 255}) {
      if (level < 0) {
        return Color.fromARGB(255, 228, 220, 220);
      }
      for (ColourLevelDTO colorObj in colourPerLevel
          .coloursGroups[group % (colourPerLevel.coloursGroups.length)]
          .colourLevelList) {
        if (colorObj.level == level) {
          return colorObj.color; // Return the color for the matching level
        }
        if (level == 6) {
          return Colors.white;
        }
      }
      return Color.fromARGB(255, 228, 220, 220);
    }

    return getColor(level, group,
        alpha: 255); // Change alpha value here (0-255)
  }
}
