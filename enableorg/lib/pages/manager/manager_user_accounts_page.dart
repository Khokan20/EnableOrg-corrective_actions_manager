import 'package:enableorg/controller/manager/manager_user_accounts_controller.dart';
import 'package:enableorg/models/user.dart';
import 'package:enableorg/widgets/manager/manager_user_accounts_singleadd_form.dart';
import 'package:enableorg/widgets/manager/manager_user_display.dart';
import 'package:flutter/material.dart';

import '../../widgets/manager/manager_user_upload_form.dart';

class ManagerUserAccountsPage extends StatefulWidget {
  final User user;

  ManagerUserAccountsPage({required this.user});
  @override
  State<ManagerUserAccountsPage> createState() =>
      _ManagerUserAccountsPageState();
}

class _ManagerUserAccountsPageState extends State<ManagerUserAccountsPage> {
  late ManagerUserAccountsController _controller;
  List<List<dynamic>> csvData = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _controller = ManagerUserAccountsController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void onCSVUpload(List<List<dynamic>> data) {
    setState(() {
      csvData = data;
    });
    _controller.processCSVData(csvData);
    _controller.uploadCSVData(context, widget.user);
  }

  Future<List<User>> getUsersWithSearch(String searchParam) {
    return _controller.getUsers(context, searchParam);
  }

  void searchUsers() {
    String searchParam = _searchController.text;
    setState(() {
      // Call the getUsersWithSearch function to update the user list
      getUsersWithSearch(searchParam);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager User Accounts'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ManagerUserAccountsForm(
                    isManager: _controller.isManager,
                    onToggleManager: _controller.toggleManager,
                    onRegisterUser: _controller.registerUser,
                    currentUser: widget.user,
                    getDepartments: _controller.getDepartments,
                    getLocations: _controller.getLocations,
                  ),
                ),
                ManagerUserUploadForm(
                  onCSVUpload: onCSVUpload,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: searchUsers,
                    child: Text('Search'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: UserListView(
                  currentUser: widget.user,
                  getUsers: getUsersWithSearch,
                  searchParam: _searchController.text,
                  onEdit: _controller.onEdit,
                  onDelete: _controller.onDelete,
                  getDepartments: _controller.getDepartments,
                  getLocations:
                      _controller.getLocations, // Pass the searchParam value
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
