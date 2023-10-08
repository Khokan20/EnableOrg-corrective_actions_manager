import 'package:cloud_firestore/cloud_firestore.dart';

import 'step_action.dart';

class CorrectiveActions {
  String caid;
  final Timestamp completionDate;
  final String staffLeadUID;
  final Timestamp targetCompletionDate;
  final List<StepAction> steps;
  final String managerUID;
  final Timestamp creationTimestamp;

  CorrectiveActions({
    required this.caid,
    required this.completionDate,
    required this.staffLeadUID,
    required this.targetCompletionDate,
    required this.steps,
    required this.managerUID,
    required this.creationTimestamp,
  });

  factory CorrectiveActions.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CorrectiveActions(
      caid: doc.id,
      completionDate: data['completionDate'] ?? Timestamp.now(),
      staffLeadUID: data['staffLeadUID'] ?? '',
      targetCompletionDate: data['targetCompletionDate'] ?? Timestamp.now(),
      steps: (data['steps'] as List<dynamic>)
          .map((stepData) => StepAction.fromMap(stepData))
          .toList(),
      managerUID: data['managerUID'] ?? '',
      creationTimestamp: data['creationTimestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completionDate': completionDate,
      'staffLeadUID': staffLeadUID,
      'targetCompletionDate': targetCompletionDate,
      'steps': steps.map((step) => step.toMap()).toList(),
      'managerUID': managerUID,
      'creationTimestamp': creationTimestamp,
    };
  }

  Future<void> update() async {
    try {
      await FirebaseFirestore.instance
          .collection('CorrectiveAction')
          .doc(caid)
          .update(toMap());
    } catch (e) {
      print('Error updating corrective action: $e');
      rethrow;
    }
  }

  Future<void> create() async {
    try {
      await FirebaseFirestore.instance
          .collection('CorrectiveAction')
          .add(toMap());
    } catch (e) {
      print('Error creating corrective action: $e');
      rethrow;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('CorrectiveAction')
          .doc(caid)
          .delete();
    } catch (e) {
      print('Error deleting corrective action: $e');
      rethrow;
    }
  }

  Future<void> mockCreate() async {
    try {
      // Define a list of mock CorrectiveActions
      final List<CorrectiveActions> mockActions = [
        CorrectiveActions(
          caid: '1',
          completionDate: Timestamp.now(),
          staffLeadUID: 'staff_lead_1',
          targetCompletionDate: Timestamp.now(),
          steps: [
            StepAction(step: 'Step 1', description: 'Description 1'),
            StepAction(step: 'Step 2', description: 'Description 2'),
          ],
          managerUID: 'manager_1',
          creationTimestamp: Timestamp.now(),
        ),
        CorrectiveActions(
          caid: '2',
          completionDate: Timestamp.now(),
          staffLeadUID: 'staff_lead_2',
          targetCompletionDate: Timestamp.now(),
          steps: [
            StepAction(step: 'Step 1', description: 'Description 1'),
          ],
          managerUID: 'manager_2',
          creationTimestamp: Timestamp.now(),
        ),
        // Add more mock CorrectiveActions as needed
      ];

      // Create each mock CorrectiveAction in the database
      for (final action in mockActions) {
        await FirebaseFirestore.instance
            .collection('CorrectiveAction')
            .add(action.toMap());
      }

      print('Mock CorrectiveActions created successfully.');
    } catch (e) {
      print('Error creating mock CorrectiveActions: $e');
      rethrow;
    }
  }
}
