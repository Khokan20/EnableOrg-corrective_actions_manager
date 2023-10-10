import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final double width;
  final double height;

  CustomDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.width = 180.0,
    this.height = 36.0,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  double? _maxTextWidth;

  @override
  void initState() {
    super.initState();
    _calculateMaxTextWidth();
  }

  void _calculateMaxTextWidth() {
    double maxTextWidth = 0.0;

    for (DropdownMenuItem<T> item in widget.items) {
      final double textWidth = _calculateTextWidth(item.child as Text);
      if (textWidth > maxTextWidth) {
        maxTextWidth = textWidth;
      }
    }

    setState(() {
      _maxTextWidth = maxTextWidth;
    });
  }

  double _calculateTextWidth(Text textWidget) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: textWidget.data),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      color: Color.fromARGB(255, 5, 36, 83), // Set the background color here
      child: DropdownButton<T>(
        value: widget.value,
        onChanged: widget.onChanged,
       // icon: null, // Remove the dropdown arrow icon
        iconDisabledColor: null, // Remove the disabled icon color
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Cormorant Garamond',
          fontWeight: FontWeight.w400,
        ),
        dropdownColor: Color.fromARGB(255, 5, 36, 83),
        items: widget.items.map((DropdownMenuItem<T> item) {
          // Wrap the child in Center to align text at the center
          return DropdownMenuItem<T>(
            value: item.value,
            child: Center(child: item.child),
          );
        }).toList(),
      ),
    );
  }
}
