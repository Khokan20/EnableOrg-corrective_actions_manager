import 'package:enableorg/ui/customTexts.dart';
import 'package:enableorg/ui/custom_button.dart';
import 'package:flutter/material.dart';

class HomeReportsFilter extends StatefulWidget {
  @override
  State<HomeReportsFilter> createState() => _HomeReportsFilterState();
}

class _HomeReportsFilterState extends State<HomeReportsFilter> {
  String? _selectedMainFilter;
  List<String> _selectedSubFilters = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomButton(
              onPressed: () => _showMainFilterDropdown(context),
              text: Text('Filter', style: CustomTextStyles.generalButtonText),
              height: 40,
              width: 100,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Wrap(
                children: _selectedSubFilters.map((filter) {
                  return Chip(
                    label: Text(filter),
                    onDeleted: () {
                      setState(() {
                        _selectedSubFilters.remove(filter);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMainFilterDropdown(BuildContext context) {
    final List<String> mainFilters = ['Location', 'Country', 'Department'];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: mainFilters.map((filter) {
            return ListTile(
              title: Text(filter),
              onTap: () {
                setState(() {
                  _selectedMainFilter = filter;
                  _selectedSubFilters.clear();
                });
                Navigator.of(context).pop();
                _showSubFilterDropdown(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showSubFilterDropdown(BuildContext context) {
    final Map<String, List<String>> subFilters = {
      'Location': ['Location 1', 'Location 2', 'Location 3'],
      'Country': ['Country A', 'Country B', 'Country C'],
      'Department': ['Department X', 'Department Y', 'Department Z'],
    };

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final List<String> subFilterList =
            subFilters[_selectedMainFilter!] ?? [];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: subFilterList.map((filter) {
            return CheckboxListTile(
              title: Text(filter),
              value: _selectedSubFilters.contains(filter),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      _selectedSubFilters.add(filter);
                    } else {
                      _selectedSubFilters.remove(filter);
                    }
                  }
                });
              },
            );
          }).toList(),
        );
      },
    );
  }
}
