import 'package:flutter/material.dart';

class StyledDropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final Function(String) addItem; // Add this line

  final String hintText;

  StyledDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.addItem,
    required this.hintText,
  });

  @override
  State<StyledDropdown> createState() => _StyledDropdownState();
}

class _StyledDropdownState extends State<StyledDropdown> {
  String? newLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 5, 36, 83),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.value,
              dropdownColor: Color.fromARGB(255, 5, 36, 83),
              onChanged: (newValue) {
                if (newValue == null) {
                  if (widget.items.contains(widget.hintText)) {
                    _showAddItemDialog(context);
                  }
                } else if (newValue == 'add_new') {
                  _showAddItemDialog(context);
                } else {
                  widget.onChanged(newValue);
                }
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.hintText,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontFamily: 'Cormorant Garamond',
                      ),
                    ),
                  ),
                ),
                ...widget.items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Cormorant Garamond',
                        ),
                      ),
                    ),
                  );
                }),
                DropdownMenuItem<String>(
                  value: 'add_new',
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '+ Add new',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Cormorant Garamond',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Add New Location',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Cormorant Garamond',
            ),
          ),
          content: TextField(
            onChanged: (value) {
              setState(() {
                newLocation = value;
              });
            },
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Cormorant Garamond',
            ),
            decoration: InputDecoration(
              hintText: 'Enter new location',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Cormorant Garamond',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (newLocation != null && newLocation!.isNotEmpty) {
                  widget.addItem(newLocation!); // Use the callback here
                  widget.onChanged(newLocation);
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Cormorant Garamond',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
