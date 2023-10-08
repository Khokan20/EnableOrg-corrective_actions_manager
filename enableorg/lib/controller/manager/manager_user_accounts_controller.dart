// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/models/department.dart';
import 'package:enableorg/models/location.dart';
import 'package:enableorg/models/user.dart' as model;
import 'package:enableorg/services/signon_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class ManagerUserAccountsController {
  bool isManager;
  List<List<dynamic>> csvData;

  ManagerUserAccountsController()
      : isManager = false,
        csvData = [];

  void toggleManager() {
    isManager = !isManager;
  }

  Future<bool> registerUser(
      BuildContext context,
      model.User manager,
      String departmentName,
      String country,
      String siteLocation,
      String email,
      String name,
      {bool showDialog = true}) async {
    try {
      print("Registering user...");

      final location = await Location.getOrCreateLocation(
          country, siteLocation, manager.cid);

      Department department =
          await Department.getOrCreateDepartment(departmentName, manager.cid);

      final password = randomAlphaNumeric(8);

      // Get the SecondaryApp instance from the FirebaseSecondaryApp class
      FirebaseApp? secondaryApp = await FirebaseSecondaryApp.secondaryApp;
      if (secondaryApp == null) {
        // Handle the case when SecondaryApp is not initialized
        print('SecondaryApp is not initialized');
        return false;
      }
      final FirebaseAuth secondaryAuth =
          FirebaseAuth.instanceFor(app: secondaryApp);

      final UserCredential userCredential =
          await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Don't forget to delete the newly created user account
      // await userCredential.user?.delete();

      await secondaryAuth.sendPasswordResetEmail(email: email);

      // Delete the secondary Firebase instance.
      // await secondaryApp.delete();

      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('User');

      final model.User userTocreate = model.User(
        uid: userCredential.user!.uid,
        email: email,
        isManager: isManager,
        managerId: manager.uid,
        did: department.did,
        cid: manager.cid,
        lid: location.lid,
        name: name,
      );

      final Map<String, dynamic> userData = userTocreate.toMap();

      await usersCollection
          .doc(userCredential.user!.uid)
          .set(userData); // Use the Map representation

      print(userData);

      if (showDialog) {
        _showRegistrationSuccessDialog(context);
      }

      return true;
    } catch (e) {
      print('Registration Error: $e');
      if (showDialog) {
        _showErrorDialog(context);
      }
      return false;
    }
  }

  Future<List<model.User>> getUsers(
      BuildContext context, String searchParam) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('User').get();

      List<model.User> users = [];

      for (var doc in snapshot.docs) {
        final model.User user = model.User.fromDocumentSnapshot(doc);
        final userMailLowerCase = user.email.toLowerCase();
        final nameLowerCase = user.name.toLowerCase();

        final searchParamLowerCase = searchParam.toLowerCase();

        if (searchParam.isEmpty ||
            userMailLowerCase.contains(searchParamLowerCase) ||
            nameLowerCase.contains(searchParamLowerCase)) {
          users.add(user);
        }
      }

      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<List<Location>> getLocations(String cid) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Location').get();

      List<Location> locations = [];

      for (var doc in snapshot.docs) {
        final Location location = Location.fromDocumentSnapshot(doc);
        if (location.cid == cid) {
          locations.add(location);
        }
      }
      return locations;
    } catch (e) {
      print('Error fetching locations: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<List<Department>> getDepartments(String cid) async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Department').get();

      List<Department> departments = [];

      for (var doc in snapshot.docs) {
        final Department department = Department.fromDocumentSnapshot(doc);
        if (department.cid == cid) {
          departments.add(department);
        }
      }
      return departments;
    } catch (e) {
      print('Error fetching departments: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<void> uploadCSVData(BuildContext context, model.User manager) async {
    if (csvData.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Empty CSV'),
          content: Text('No CSV data to upload.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    List<List<dynamic>> failedEmails = [];

    for (var row in csvData) {
      final email = row[0].toString().trim();
      final name = row[1].toString().trim();
      isManager = row[2].toString().trim().toLowerCase() == 'true';
      final department = row[3].toString().trim();
      final country = row[4].toString().trim();
      final siteLocation = row[5].toString().trim();

      /* Get or create the location */

      /* Get or create the department is part of registerUser*/
      /* Register the user using the registerUser function */
      final isSuccess = await registerUser(
          context, manager, department, country, siteLocation, email, name,
          showDialog: false);

      if (!isSuccess) {
        failedEmails.add(row);
      }
    }

    if (failedEmails.isNotEmpty) {
      String errorMessage =
          'Failed to register or update the following emails as they already exist:\n\n';

      for (var failedRow in failedEmails) {
        final failedEmail = failedRow[0].toString().trim();
        errorMessage += '- $failedEmail\n';
      }
      _showUploadFailureDialog(context, errorMessage);
    } else {
      _showUploadSuccessDialog(context);
    }
  }

  void processCSVData(List<List<dynamic>> data) {
    csvData = data;

    // Process and manipulate the CSV data as per your requirements
    // Here, you can perform operations on the csvData list

    // print(csvData);
  }

  _showRegistrationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Registration Success'),
        content: Text(
            'User registered successfully. Check your email for the password.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Registration Error'),
        content: Text('Failed to register. Email already exists.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  _showUploadSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Success'),
          content: Text('CSV data uploaded successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUploadFailureDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration/Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> onEdit(model.User user) async {
    try {
      user.updateInFirestore();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> onDelete(model.User user) async {
    try {
      user.deleteFromFirestore();
      return true;
    } catch (e) {
      return false;
    }
  }
}
