import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/department.dart';
import 'package:enableorg/models/location.dart';
import 'package:enableorg/ui/custom_button.dart';
import 'package:enableorg/ui/styled_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../../models/user.dart';

class ManagerUserAccountsForm extends StatefulWidget {
  final User currentUser;
  final bool isManager;
  final Function() onToggleManager;
  final Future<bool> Function(
          BuildContext, User, String, String, String, String, String)
      onRegisterUser;
  final Future<List<Department>> Function(String) getDepartments;
  final Future<List<Location>> Function(String) getLocations;

  ManagerUserAccountsForm({
    required this.isManager,
    required this.onToggleManager,
    required this.onRegisterUser,
    required this.currentUser,
    required this.getDepartments,
    required this.getLocations,
  });

  @override
  State<ManagerUserAccountsForm> createState() =>
      _ManagerUserAccountsFormState();
}

class _ManagerUserAccountsFormState extends State<ManagerUserAccountsForm> {
  bool _isManager = false;
  String _email = '';
  String? _selectedCountry;
  String? _selectedLocation;
  String? _selectedDepartment;
  String _name = '';

  @override
  void initState() {
    _isManager = widget.isManager;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ManagerUserAccountsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isManager != widget.isManager) {
      _isManager = widget.isManager;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              CustomButton(
                onPressed: () => _showAddEmployeeDialog(context),
                width: 200,
                text: Text(
                  '+ Add Employee',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final buildContext = dialogContext;
        return FutureBuilder(
          future: Future.wait([
            widget.getDepartments(widget.currentUser.cid),
            widget.getLocations(widget.currentUser.cid),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error loading data');
            } else {
              List<Department> departmentList = snapshot.data?[0];
              List<Location> locationList = snapshot.data?[1];
              List<String> countryList =
                  getCountriesFromLocations(locationList);

              void addCountry(String newCountry) {
                setState(() {
                  countryList.add(newCountry);
                });
              }

              void addLocation(String newLocation) {
                setState(() {
                  locationList.add(Location(
                      cid: widget.currentUser.cid,
                      lid: randomAlpha(30),
                      siteLocation: newLocation,
                      country: _selectedCountry!));
                });
              }

              void addDepartment(String newDepartment) {
                setState(() {
                  departmentList.add(Department(
                      did: randomAlpha(30),
                      name: newDepartment,
                      description: 'This is dummy',
                      creationTimestamp: Timestamp.now(),
                      cid: widget.currentUser.cid));
                });
              }

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Dialog(
                    child: SingleChildScrollView(
                      // Add this wrapper
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width *
                            0.3, // Adjust the width
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: StyledDropdown(
                                    value: _selectedCountry,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedCountry = newValue;
                                        _selectedLocation = null;
                                      });
                                    },
                                    items: countryList,
                                    hintText: 'Select Country',
                                    addItem: addCountry,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: StyledDropdown(
                                    value: _selectedLocation,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedLocation = newValue;
                                      });
                                    },
                                    items: locationList
                                        .where((location) =>
                                            location.country ==
                                            _selectedCountry)
                                        .map(
                                            (location) => location.siteLocation)
                                        .toList(),
                                    hintText: 'Select Location',
                                    addItem: addLocation,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            StyledDropdown(
                              value: _selectedDepartment,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDepartment = newValue;
                                });
                              },
                              items: departmentList
                                  .map((department) => department.name)
                                  .toList(),
                              hintText: 'Select Department',
                              addItem: addDepartment,
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Cormorant Garamond',
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter email',
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  _name = value;
                                });
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Cormorant Garamond',
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter name',
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Manager?',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Cormorant Garamond',
                                  ),
                                ),
                                Checkbox(
                                  value: _isManager,
                                  onChanged: (value) {
                                    setState(() {
                                      _isManager = value!;
                                      widget.onToggleManager();
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(buildContext);
                                    _selectedDepartment = null;
                                    _selectedCountry = null;
                                    _selectedLocation = null;
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
                                  onPressed: () async {
                                    print("Calling Register function...");
                                    if (_validateFields()) {
                                      bool success =
                                          await widget.onRegisterUser(
                                        buildContext,
                                        widget.currentUser,
                                        _selectedDepartment!,
                                        _selectedCountry!,
                                        _selectedLocation!,
                                        _email,
                                        _name,
                                      );
                                      if (success) {
                                        _isManager = false;
                                        _selectedDepartment = null;
                                        _selectedCountry = null;
                                        _selectedLocation = null;
                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName(
                                                '/manager/home'));
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Add User',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Cormorant Garamond',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  bool _validateFields() {
    return true;
  }

 /*  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Department added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
                Navigator.pushReplacementNamed(context, '/manager/home');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

 Widget _buildErrorWidget(String? errorText) {
    if (errorText == null) {
      return SizedBox
          .shrink(); // Hide the error message container if there's no error
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        errorText,
        style: TextStyle(color: Colors.red),
      ),
    );
  }*/

  List<String> getCountriesFromLocations(List<Location> locationList) {
    List<String> countryList = [];
    for (var location in locationList) {
      if (!countryList.contains(location.country)) {
        countryList.add(location.country);
      }
    }
    return countryList;
  }
}
