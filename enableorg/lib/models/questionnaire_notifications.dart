import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionnaireNotificationTypes {
  FB_COMPLETE,
  FB_REMIND,
  WB_COMPLETE,
  WB_REMIND,
  PUL_COMPLETE
}

class QuestionnaireNotification {
  final String qnid;
  final QuestionnaireNotificationTypes type;
  final Timestamp creationTimestamp;
  Timestamp startTimestamp;
  Timestamp expiryTimestamp;
  final String uid;

  QuestionnaireNotification({
    required this.qnid,
    required this.startTimestamp,
    required this.type,
    required this.creationTimestamp,
    required this.expiryTimestamp,
    required this.uid,
  });

  factory QuestionnaireNotification.fromDocumentSnapshot(
      DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final typeString = data['type'] as String;
    final uid = data['uid'] as String;
    final creationTimestamp = data['creationTimestamp'] as Timestamp;
    final expiryTimestamp = data['expiryTimestamp'] as Timestamp;
    final startTimestamp = data['startTimestamp'] as Timestamp;
    final qnid = data['qnid'] as String;

    final type = _mapStringToQuestionnaireNotificationType(typeString);

    return QuestionnaireNotification(
        startTimestamp: startTimestamp,
        type: type,
        creationTimestamp: creationTimestamp,
        expiryTimestamp: expiryTimestamp,
        uid: uid,
        qnid: qnid);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'creationTimestamp': creationTimestamp,
      'expiryTimestamp': expiryTimestamp,
      'uid': uid,
      'startTimestamp': startTimestamp,
      'qnid': qnid
    };
  }

  static QuestionnaireNotificationTypes
      _mapStringToQuestionnaireNotificationType(String categoryString) {
    switch (categoryString) {
      case 'FB_COMPLETE':
        return QuestionnaireNotificationTypes.FB_COMPLETE;
      case 'FB_REMIND':
        return QuestionnaireNotificationTypes.FB_REMIND;
      case 'WB_REMIND':
        return QuestionnaireNotificationTypes.WB_REMIND;
      case 'WB_COMPLETE':
        return QuestionnaireNotificationTypes.WB_COMPLETE;
      default:
        throw Exception('Invalid category string: $categoryString');
    }
  }
}
