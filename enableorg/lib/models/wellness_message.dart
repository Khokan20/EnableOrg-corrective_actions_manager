import 'package:cloud_firestore/cloud_firestore.dart';

class WellnessMessage {
  final int value;
  final String message;
  final String senderUID;
  final String recipientUID;
  final Timestamp creationTimestamp;
  late bool readStatus;
  final bool isAnonymous;

  final String wmid;

  WellnessMessage(
      {this.isAnonymous = false,
      required this.message,
      required this.senderUID,
      required this.recipientUID,
      required this.creationTimestamp,
      required this.readStatus,
      required this.wmid,
      required this.value});

  factory WellnessMessage.fromDocumentSnapshot(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WellnessMessage(
        wmid: data['wmid'] as String,
        message: data['message'] as String,
        senderUID: data['senderUID'] as String,
        recipientUID: data['recipientUID'] as String,
        creationTimestamp: data['creationTimestamp'] as Timestamp,
        readStatus: data['readStatus'] as bool,
        value: data['value'] as int,
        isAnonymous: data['isAnonymous'] as bool);
  }

  Map<String, dynamic> toMap() {
    return {
      'wmid': wmid,
      'message': message,
      'senderUID': senderUID,
      'recipientUID': recipientUID,
      'creationTimestamp': creationTimestamp,
      'readStatus': readStatus,
      'isAnonymous': isAnonymous,
      'value': value
    };
  }
}
