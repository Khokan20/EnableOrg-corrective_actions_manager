import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color outlineColor;
  final Color startColor;
  final Color endColor;

  CustomLinearProgressIndicator({
    required this.value,
    required this.outlineColor,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10, // Adjust the height as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), // Rounded edges
        border: Border.all(color: outlineColor), // Outline color
      ),
      child: Stack(
        children: [
          LinearProgressIndicator(
            value: 1.0, // Full width for the outline
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), // Rounded edges
              gradient: LinearGradient(
                colors: [startColor, endColor], // Gradient colors
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            width: MediaQuery.of(context).size.width * (value / 100),
          ),
        ],
      ),
    );
  }
}
