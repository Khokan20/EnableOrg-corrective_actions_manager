import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionAnswer {
  final String qaid;
  final String qid;
  final String uid;
  final Timestamp creationTimestamp;
  final int answer;
  final String qnid;

  QuestionAnswer(
      {required this.answer,
      required this.qnid,
      required this.qaid,
      required this.creationTimestamp,
      required this.qid,
      required this.uid});

  factory QuestionAnswer.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final qaid = snapshot.id;
    final answer = data['answer'] as int;
    final qid = data['qid'] as String;
    final uid = data['uid'] as String;
    final creationTimestamp = data['creationTimestamp'] as Timestamp;
    final qnid = data['qnid'] as String;
    return QuestionAnswer(
        qnid: qnid,
        qaid: qaid,
        qid: qid,
        uid: uid,
        creationTimestamp: creationTimestamp,
        answer: answer);
  }

  Map<String, dynamic> toMap() {
    return {
      'qaid': qaid,
      'qid': qid,
      'uid': uid,
      'creationTimestamp': creationTimestamp,
      'answer': answer,
      'qnid': qnid
    };
  }
}
