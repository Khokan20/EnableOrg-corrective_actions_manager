import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/controller/manager/manager_questionnaire_notification.dart';
import 'package:enableorg/models/corrective_actions.dart';

class ManagerCorrectiveActionsController {
  // Constructor if needed
  ManagerCorrectiveActionsController();

  Future<List<CorrectiveActions>?>? getFBCorrectiveActions(String uid) async {
    try {
      final questionnaireNotificationController =
          ManagerQuestionnaireNotificationController();

      DateTime? expiryDate =
          await questionnaireNotificationController.getFBCurrentExpiryDate(uid);

      if (DateTime.now().isAfter(expiryDate!)) {
        return newFBCorrectiveActionsReport();
      }

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('CorrectiveAction')
          .where('managerUID',
              isEqualTo: uid) // Additional parameter on action type
          .get();

      List<CorrectiveActions> correctiveActions = [];

      for (var doc in snapshot.docs) {
        final CorrectiveActions correctiveAction =
            CorrectiveActions.fromDocumentSnapshot(doc);
        correctiveActions.add(correctiveAction);
      }

      return correctiveActions;
    } catch (e) {
      print('Error fetching corrective actions: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<List<CorrectiveActions>?>? newFBCorrectiveActionsReport() {
    // Needs to query
    return null;
  }
}
