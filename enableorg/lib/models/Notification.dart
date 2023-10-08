import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String title;
  final String message;
  final String senderUID;
  final List<dynamic> recipientUID;
  final Timestamp creationTimestamp;
  final String nid;

  Notification(
      {required this.title,
      required this.message,
      required this.senderUID,
      required this.recipientUID,
      required this.creationTimestamp,
      required this.nid});

  factory Notification.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Notification(
      title: data['title'] as String,
      nid: data['nid'] as String,
      message: data['message'] as String,
      senderUID: data['senderUID'] as String,
      recipientUID: data['recipientUID'] as List<dynamic>,
      creationTimestamp: data['creationTimestamp'] as Timestamp,
    );
  }
}
