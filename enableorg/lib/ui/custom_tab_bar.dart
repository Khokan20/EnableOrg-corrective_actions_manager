import 'package:flutter/material.dart';

import 'customTexts.dart';

class CustomTabulation extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> tabContent;

  CustomTabulation({required this.tabs, required this.tabContent});

  @override
  State<CustomTabulation> createState() => _CustomTabulationState();
}

class _CustomTabulationState extends State<CustomTabulation> {
  int _currentIndex = 0; // Index to track the active section

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // width: 150,
          //  height: 100,
          decoration: BoxDecoration(
          //  color: Colors.transparent,
           // border: null,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), // Top left corner rounded
              topRight: Radius.circular(20), // Top right corner rounded
            ),
          ),
          padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: ToggleButtons(
            isSelected: widget.tabs
                .asMap()
                .map((index, _) => MapEntry(index, _currentIndex == index))
                .values
                .toList(),
            onPressed: (index) {
              setState(() {
                _currentIndex = index; // Toggle between sections
              });
            },
             borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), // Top left corner rounded
                        topRight:
                            Radius.circular(20), // Top right corner rounded
                      ),
            //   selectedColor: const Color.fromARGB(255, 255, 255, 255),
            color: Color.fromARGB(255, 7, 2, 54), // Light grey when not clicked
          //  fillColor: Colors.transparent, // Dark blue when clicked
            children: widget.tabs.map((tab) {
              return SizedBox(
                width: 150.0,
                child: Container(
                  decoration: BoxDecoration(
                      border: null,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), // Top left corner rounded
                        topRight:
                            Radius.circular(20), // Top right corner rounded
                      ),
                      color: Color.fromARGB(255, 5, 36, 83) // Background color
                      //  color: Color.fromARGB(0, 3, 2, 80),
                      ), // Increase the size of the rectangles
                  child: Center(
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: _currentIndex == widget.tabs.indexOf(tab)
                          ? CustomTextStyles
                              .tabTextSelected // Selected tab text style
                          : CustomTextStyles
                              .tabTextUnselected, // Unselected tab text style
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 8.0),
          child: Container(
            height: 1.0, // Height of the horizontal bar
            color: Color.fromARGB(255, 5, 36, 83), // Grey bar color
            margin: EdgeInsets.symmetric(
                horizontal: 8.0), // Margin to stretch the bar
          ),
        ),
        Expanded(
          child: widget.tabContent[_currentIndex],
        ),
      ],
    );
  }
}
