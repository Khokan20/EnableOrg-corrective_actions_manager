// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/department.dart';
import 'package:enableorg/models/location.dart';
import 'package:enableorg/ui/styled_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:enableorg/models/user.dart';
import 'package:random_string/random_string.dart';

class UserListView extends StatefulWidget {
  final User currentUser;
  final Future<List<User>> Function(String) getUsers;
  final String searchParam;
  final Future<bool> Function(User) onEdit;
  final Function(User) onDelete;
  final Future<List<Department>> Function(String) getDepartments;
  final Future<List<Location>> Function(String) getLocations;

  UserListView(
      {required this.getUsers,
      required this.searchParam,
      required this.onEdit,
      required this.onDelete,
      required this.currentUser,
      required this.getDepartments,
      required this.getLocations});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  late Future<List<User>> _userListFuture;

  @override
  void initState() {
    super.initState();
    _loadUserList();
  }

  void _loadUserList() {
    setState(() {
      _userListFuture = widget.getUsers(widget.searchParam).whenComplete(() {
        setState(() {});
      });
    });
  }

  @override
  void didUpdateWidget(UserListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchParam != oldWidget.searchParam) {
      _loadUserList();
    }
  }

  Future<void> _showUserDialog(User user) async {
    String name = user.name;
    bool isManager = user.isManager;
    String? selectedCountry =
        await Location.getLocationCountryWithlid(user.lid);
    String? selectedLocation = await Location.getLocationNameWithlid(user.lid);
    String? selectedDepartment =
        await Department.getDepartmentNameWithDid(user.did);
    showDialog(
      context: context,
      builder: (BuildContext context) {
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

              /* Remove current ones from the list to avoid double-ups */
              // departmentList.remove(widget.currentUser.did);
              // locationList.remove(selectedLocation);
              // countryList.remove(selectedCountry);
              void addCountry(String newCountry) {
                setState(() {
                  countryList.add(newCountry);
                });
              }

              void resetDropdowns() {
                // setState(() {
                //   selectedCountry = null;
                //   selectedLocation = null;
                //   selectedDepartment = null;
                // });
              }

              void addLocation(String newLocation) {
                setState(() {
                  locationList.add(Location(
                      cid: widget.currentUser.cid,
                      lid: randomAlpha(30),
                      siteLocation: newLocation,
                      country: selectedCountry!));
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
                  return AlertDialog(
                    title: Text('Edit User'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StyledDropdown(
                          value: selectedCountry,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCountry = newValue!;
                              selectedLocation = null;
                            });
                          },
                          items: countryList.toSet().toList(),
                          hintText: 'Select Country',
                          addItem: addCountry,
                        ),
                        SizedBox(height: 8),
                        StyledDropdown(
                          value: selectedLocation,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLocation = newValue;
                            });
                          },
                          items: locationList
                              .where((location) =>
                                  location.country == selectedCountry)
                              .map((location) => location.siteLocation)
                              .toSet()
                              .toList(),
                          hintText: 'Select Location',
                          addItem: addLocation,
                        ),
                        SizedBox(height: 8),
                        StyledDropdown(
                          value: selectedDepartment,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDepartment = newValue;
                            });
                          },
                          items: departmentList
                              .map((department) => department.name)
                              .toSet()
                              .toList(),
                          hintText: 'Select Department',
                          addItem: addDepartment,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: TextEditingController(text: name),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(height: 8),
                        CheckboxListTile(
                          title: Text('Manager'),
                          value: isManager,
                          onChanged: (value) {
                            setState(() {
                              isManager = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          // Update all fields of the user object
                          user.name = name;
                          user.isManager = isManager;
                          user.did =
                              (await Department.getDidWithNameAndCidOrCreate(
                                  selectedDepartment!,
                                  widget.currentUser.cid))!;
                          user.lid =
                              (await Location.getLidWithLocationAndCidOrCreate(
                                  selectedLocation!,
                                  selectedCountry!,
                                  widget.currentUser.cid))!;

                          bool editResult = await widget.onEdit(user);

                          if (editResult) {
                            Navigator.of(context).pop();
                            _loadUserList();
                            resetDropdowns();
                          } else {
                            _showUploadFailureDialog(context);
                            resetDropdowns();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Save'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          resetDropdowns();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _showDeleteConfirmationDialog(user);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  void _showUploadFailureDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Failure'),
          content: Text('Save did not work. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the delete operation here
                widget.onDelete(user);
                _loadUserList();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  List<String> getCountriesFromLocations(List<Location> locationList) {
    List<String> countryList = [];
    for (var location in locationList) {
      if (!countryList.contains(location.country)) {
        countryList.add(location.country);
      }
    }
    return countryList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _loadUserList,
            ),
          ],
        ),
        FutureBuilder<List<User>>(
          future: _userListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading users'),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Text('No users found'),
              );
            } else {
              final userList = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dividerThickness: 0,
                  columns: [
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(
                                fontFamily: 'Cormorant Garamond',
                                fontSize: 18))),
                    DataColumn(
                        label: Text('Department',
                            style: TextStyle(
                                fontFamily: 'Cormorant Garamond',
                                fontSize: 18))),
                    DataColumn(
                        label: Text('Location',
                            style: TextStyle(
                                fontFamily: 'Cormorant Garamond',
                                fontSize: 18))),
                    DataColumn(
                        label: Text('Manager?',
                            style: TextStyle(
                                fontFamily: 'Cormorant Garamond',
                                fontSize: 18))),
                  ],
                  rows: userList.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(
                          InkWell(
                            onTap: () {
                              _showUserDialog(user);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name,
                                    style: TextStyle(
                                        fontFamily: 'Cormorant Garamond',
                                        fontSize: 16)),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          FutureBuilder<String?>(
                            future:
                                Department.getDepartmentNameWithDid(user.did),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error');
                              } else {
                                return Text(snapshot.data ?? '',
                                    style: TextStyle(
                                        fontFamily: 'Cormorant Garamond',
                                        fontSize: 16));
                              }
                            },
                          ),
                        ),
                        DataCell(
                          FutureBuilder<String?>(
                            future: Location.getLocationNameWithlid(user.lid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error');
                              } else {
                                return Text(snapshot.data ?? '',
                                    style: TextStyle(
                                        fontFamily: 'Cormorant Garamond',
                                        fontSize: 16));
                              }
                            },
                          ),
                        ),
                        DataCell(
                          Text(user.isManager ? 'Manager' : 'Employee',
                              style: TextStyle(
                                  fontFamily: 'Cormorant Garamond',
                                  fontSize: 16)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
