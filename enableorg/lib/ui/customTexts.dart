import 'package:flutter/material.dart';

class CustomTextStyles {
  static const TextStyle generalHeaderText = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 34, // Adjust the size accordingly
    color: Color.fromARGB(255, 0, 0, 0), // Your specified shade of blue
    fontWeight: FontWeight.bold,
  );

  static const TextStyle generalBodyText = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 16, // Adjust the size accordingly
    color: Color.fromARGB(255, 5, 36, 83), // Your specified shade of blue
  );

  static const TextStyle boldedBodyText = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 16, // Adjust the size accordingly
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 0, 0), // Your specified shade of blue
  );

  static const TextStyle tabTextSelected = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 16, // Adjust the size accordingly
    color: Colors.white, // Your specified shade of blue
  );
  static const TextStyle tabTextUnselected = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 16, // Adjust the size accordingly
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 118, 116, 116), // Your specified shade of blue
  );

  static const TextStyle boldedReportsHeaderText = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 18, // Adjust the size accordingly
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 0, 0, 0), // Your specified shade of blue
  );

  static const TextStyle copyrightText = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 12, // Adjust the size accordingly
    color: Color.fromARGB(255, 5, 36, 83), // Your specified shade of blue
  );

  static const TextStyle generalButtonText = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 16, // Adjust the size accordingly
    color: Colors.white, // White text color
  );

  static const TextStyle generalErrorText = TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 16, // Adjust the size accordingly
    color: Colors.red, // Red text color
  );

  static const TextStyle medalText = TextStyle(
      fontFamily: 'Cormorant Garamond',
      fontSize: 16, // Adjust the size accordingly
      color: Color.fromARGB(255, 0, 0, 0), // Your specified shade of blue
      fontWeight: FontWeight.bold);
}
