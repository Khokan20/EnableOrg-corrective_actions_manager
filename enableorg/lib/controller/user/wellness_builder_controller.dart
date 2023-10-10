import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/dto/questionList_and_qnid_DTO.dart';
import 'package:enableorg/models/question_answer.dart';
import 'package:enableorg/models/questionnaire_notifications.dart';
import 'package:enableorg/models/user.dart';

import '../../models/question.dart';

class WellnessBuilderController {
  final User currentUser;

  WellnessBuilderController({required this.currentUser});

  Future<QuestionnaireNotification?> getRecentFBQuestionnaireNotification(
      User user) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("QuestionnaireNotification")
          .where('uid', isEqualTo: user.managerId)
          .where('type', isEqualTo: 'WB_COMPLETE')
          .orderBy('creationTimestamp', descending: true)
          .limit(1) // Get only the most recent notification
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the most recent WB_COMPLETE notification document
        DocumentSnapshot notificationDoc = querySnapshot.docs.first;
        QuestionnaireNotification notification =
            QuestionnaireNotification.fromDocumentSnapshot(notificationDoc);
        return notification;
      }
    } catch (e) {
      print('Error fetching WB_COMPLETE notification date: $e');
    }

    return null; // Return null if no WB_COMPLETE notification found
  }

  /* Returns all questions relevant to current user and the QNID 
    Empty: If no questions remaining for them to complete/completed all
    QNID stores which manager sent notification it corresponds to
  */

  Future<QuestionListAndQnidDTO> getQuestions(User user) async {
    List<Question> qList = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Question').get();

    List<Question> questions = querySnapshot.docs
        .map((doc) => Question.fromDocumentSnapshot(doc))
        .toList();

    // Get the WB_COMPLETE date from the most recent notification
    QuestionnaireNotification? notification =
        await getRecentFBQuestionnaireNotification(user);

    if (notification == null) {
      QuestionListAndQnidDTO questionListAndQnidDTO =
          QuestionListAndQnidDTO(qList: qList, qnid: null);
      return questionListAndQnidDTO;
    }
    print("${notification.qnid} Is being checked");
    DateTime? wbCompletionDate = notification.expiryTimestamp.toDate();
    DateTime? fbStartingDate = notification.startTimestamp.toDate();
    String? qnid = notification.qnid;

    if (fbStartingDate.isAfter(DateTime.now())) {
      // Handle the case when no WB_COMPLETE notification is found
      print('No WB_COMPLETE notification found.');
      QuestionListAndQnidDTO questionListAndQnidDTO =
          QuestionListAndQnidDTO(qList: qList, qnid: qnid);
      return questionListAndQnidDTO;
    }

    // Define the quantum date (WB_COMPLETE notification date + Expiry time)
    // For example, assuming expiryTime is 6 months

    QuerySnapshot answeredQuestionsSnapshot = await FirebaseFirestore.instance
        .collection('User')
        .doc(user.uid)
        .collection('QuestionAnswers')
        .where('qnid', isEqualTo: qnid)
        .get();

    List<QuestionAnswer> answeredQuestions = answeredQuestionsSnapshot.docs
        .map((doc) => QuestionAnswer.fromDocumentSnapshot(doc))
        .toList();

    for (Question question in questions) {
      // Check if the question is a WELLNESS_BUILDER category
      if (question.category == QuestionCategory.WELLNESS_BUILDER) {
        // Has this question been answered already?
        bool isQuestionAnsweredInQuantum = answeredQuestions.any((qa) {
          return qa.qid == question.qid;
        });
        // Has this question expired?
        bool isQuestionExpired =
            Timestamp.now().toDate().isAfter(wbCompletionDate);

        print(isQuestionAnsweredInQuantum);
        // Add the question to qList if it hasn't been answered in the last quantum
        if (!isQuestionAnsweredInQuantum && !isQuestionExpired) {
          qList.add(question);
        }
      }
    }
    QuestionListAndQnidDTO questionListAndQnidDTO =
        QuestionListAndQnidDTO(qList: qList, qnid: qnid);
    return questionListAndQnidDTO;
  }

  Future<bool> saveAndNext(List<QuestionAnswer> questionAnswers) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('User').doc(currentUser.uid);
      final questionAnswersRef = userRef.collection('QuestionAnswers');

      for (var questionAnswer in questionAnswers) {
        await questionAnswersRef
            .doc(questionAnswer.qaid)
            .set(questionAnswer.toMap());
      }

      print('Question answers saved successfully!');
      return true;
    } catch (e) {
      print('Failed to save question answers: $e');
      return false;
    }
  }

  Future<bool> checkFBRemind(User user) async {
    QuestionnaireNotification? qn =
        await getRecentFBQuestionnaireNotification(user);

    if (qn == null) {
      return false;
    }
    /* Check if there is a db entry with type WB_REMIND with qn.qnid */
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('QuestionnaireNotification')
        .where('qnid', isEqualTo: qn.qnid)
        .where('type',
            isEqualTo: QuestionnaireNotificationTypes.WB_REMIND
                .toString()
                .split('.')
                .last)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("No remind was found");
      return false;
    }
    QuestionnaireNotification remindNotif =
        QuestionnaireNotification.fromDocumentSnapshot(
            querySnapshot.docs.first);

    if (querySnapshot.docs.isEmpty ||
        remindNotif.expiryTimestamp.toDate().isAfter(DateTime.now())) {
      print("No remind was found | Last possible one has expired");
      // No reminder has been sent
      return false;
    }

    /* Check if we haven't completed the survey */
    // Get the 'QuestionAnswer' sub-collection for each user
    CollectionReference questionAnswersCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(user.uid)
        .collection('QuestionAnswers');
    // Get the documents in the 'QuestionAnswers' subcollection
    QuerySnapshot questionAnswersQuerySnapshot =
        await questionAnswersCollection.get();
    // Convert the documents to a list of 'QuestionAnswer' objects
    List<QuestionAnswer> questionAnswers = questionAnswersQuerySnapshot.docs
        .map((doc) => QuestionAnswer.fromDocumentSnapshot(doc))
        .toList();

    QuerySnapshot questionsSnapshot = await FirebaseFirestore.instance
        .collection('Question')
        .where('category', isEqualTo: 'WELLNESS_BUILDER')
        .get();

    int totalQuestions = questionsSnapshot
        .docs.length; // Count completed and total for each user
    int totalCompleted = questionAnswers.where((i) => i.qnid == qn.qnid).length;

    if (totalCompleted == totalQuestions) {
      print("All questions were answered");
      return false;
    }
    return true;
  }
}
