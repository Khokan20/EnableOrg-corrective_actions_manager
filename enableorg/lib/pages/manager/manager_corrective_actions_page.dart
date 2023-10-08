import 'package:enableorg/controller/manager/manager_corrective_actions_controller.dart';
import 'package:enableorg/models/corrective_actions.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class ManagerCorrectiveActionsPage extends StatefulWidget {
  final User user;
  ManagerCorrectiveActionsPage({required this.user});
  @override
  State<ManagerCorrectiveActionsPage> createState() =>
      _ManagerCorrectiveActionsPageState();
}

class _ManagerCorrectiveActionsPageState
    extends State<ManagerCorrectiveActionsPage> {
  late ManagerCorrectiveActionsController correctiveActionsController;
  List<CorrectiveActions>? correctiveActions = [];

  @override
  void initState() {
    super.initState();
    correctiveActionsController = ManagerCorrectiveActionsController();
    _loadCorrectiveActions();
  }

  _loadCorrectiveActions() async {
    correctiveActions = await correctiveActionsController
        .getFBCorrectiveActions(widget.user.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Corrective Actions'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: DataTable(
          columns: [
            DataColumn(label: Text('CAID')),
            DataColumn(label: Text('Completion Date')),
            DataColumn(label: Text('Staff Lead')),
            DataColumn(label: Text('Target Completion Date')),
            DataColumn(label: Text('Actions')),
            DataColumn(label: Text('Manager UID')),
            DataColumn(label: Text('Creation Timestamp')),
          ],
          rows: correctiveActions!.map((action) {
            return DataRow(cells: [
              DataCell(Text(action.caid)),
              DataCell(Text(action.completionDate.toString())),
              DataCell(Text(action.staffLeadUID)),
              DataCell(Text(action.targetCompletionDate.toString())),
              DataCell(Text(action.steps
                  .toString())), // Modify this to display steps appropriately
              DataCell(Text(action.managerUID)),
              DataCell(Text(action.creationTimestamp.toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
