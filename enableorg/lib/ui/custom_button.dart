import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Icon? icon; // Icon parameter

  CustomButton({
    required this.text,
    required this.onPressed,
    this.width = 180.0,
    this.height = 36.0,
    this.icon, // Icon parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 5, 36, 83),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: TextStyle(
            color: Colors.white,
            decorationColor: Colors.white,
            fontSize: 20,
            fontFamily: 'Cormorant Garamond',
            fontWeight: FontWeight.w400,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) // Display the icon if provided
              Padding(
                padding: EdgeInsets.only(right: 8.0), // Adjust spacing as needed
                child: icon!,
              ),
            text, // Display the text
          ],
        ),
      ),
    );
  }
}
