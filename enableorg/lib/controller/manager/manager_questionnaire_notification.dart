import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/dto/completion_progress_DTO.dart';
import 'package:enableorg/dto/time_result_types.dart';
import 'package:enableorg/models/question.dart';
import 'package:enableorg/models/question_answer.dart';
import 'package:enableorg/models/questionnaire_notifications.dart';
import 'package:enableorg/models/user.dart';

class ManagerQuestionnaireNotificationController {
  Future<List<QuestionnaireNotification>>
      getAllQuestionnaireNotifications() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .get();

      final List<QuestionnaireNotification> notifications = [];

      for (var doc in snapshot.docs) {
        final QuestionnaireNotification notification =
            QuestionnaireNotification.fromDocumentSnapshot(doc);
        notifications.add(notification);
      }
      return notifications;
    } catch (e) {
      print('Error fetching questionnaire notifications: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Future<bool> createQuestionnaireNotification(
      QuestionnaireNotification notification) async {
    try {
      final notificationRef = FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .doc();

      await notificationRef.set({
        'type': notification.type.toString().split('.').last,
        'uid': notification.uid,
        'expiryTimestamp': notification.expiryTimestamp,
        'creationTimestamp': notification.creationTimestamp,
        'startTimestamp': notification.startTimestamp,
        'qnid': notification.qnid
      });
      print('${notification.type} notification sent');
      return true;
    } catch (e) {
      print('Error creating notification: $e');
      return false;
    }
  }

  Future<bool> onQuestionnaireNotificationSend(
      QuestionnaireNotification notification) async {
    try {
      return createQuestionnaireNotification(notification);
    } catch (e) {
      print('Error sending notification');
      return false;
    }
  }

  Future<QuestionnaireNotification?>
      getFBQuestionnaireNotificationScheduledNext(String uid) async {
    try {
      final now = Timestamp.now();
      final snapshot = await FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .where('startTimestamp', isGreaterThanOrEqualTo: now)
          .where('uid', isEqualTo: uid)
          .where('type',
              isEqualTo: QuestionnaireNotificationTypes.FB_COMPLETE
                  .toString()
                  .split('.')
                  .last)
          .orderBy('startTimestamp', descending: false)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final notificationDoc = snapshot.docs.first;
        return QuestionnaireNotification.fromDocumentSnapshot(notificationDoc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting questionnaire notification: $e');
      return null;
    }
  }


  Future<QuestionnaireNotification?>
      getWBQuestionnaireNotificationScheduledNext(String uid) async {
    try {
      final now = Timestamp.now();
      final snapshot = await FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .where('startTimestamp', isGreaterThanOrEqualTo: now)
          .where('uid', isEqualTo: uid)
          .where('type',
              isEqualTo: QuestionnaireNotificationTypes.WB_COMPLETE
                  .toString()
                  .split('.')
                  .last)
          .orderBy('startTimestamp', descending: false)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final notificationDoc = snapshot.docs.first;
        return QuestionnaireNotification.fromDocumentSnapshot(notificationDoc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting questionnaire notification: $e');
      return null;
    }
  }

  Future<QuestionnaireNotification?> getOngoingQuestionnaireNotification(
      String uid, QuestionnaireNotificationTypes type) async {
    try {
      final now = Timestamp.now();

      final startQuery = FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .where('startTimestamp', isLessThanOrEqualTo: now)
          .where('uid', isEqualTo: uid)
          .where('type',
              isEqualTo: type
                  .toString()
                  .split('.')
                  .last)
          .orderBy('startTimestamp', descending: true)
          .limit(1)
          .get();

      final endQuery = FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .where('expiry', isGreaterThanOrEqualTo: now)
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      final querySnapshots = await Future.wait([startQuery, endQuery]);

      final combinedList = querySnapshots
          .map((snapshot) => snapshot.docs)
          .expand((docs) => docs)
          .toList();

      if (combinedList.isNotEmpty) {
        combinedList.sort((a, b) => (a.data()['startTimestamp'] as Timestamp)
            .compareTo(b.data()['startTimestamp'] as Timestamp));

        return QuestionnaireNotification.fromDocumentSnapshot(
            combinedList.first);
      }

      return null;
    } catch (e) {
      print('Error getting ongoing questionnaire notification: $e');
      return null;
    }
  }

  Future<DateTime?> getFBCurrentExpiryDate(String uid) async {
    QuestionnaireNotification? currentQuestionnaire =
        await getOngoingQuestionnaireNotification(uid, QuestionnaireNotificationTypes.FB_COMPLETE);

    if (currentQuestionnaire == null) {
      return null;
    }
    return currentQuestionnaire.expiryTimestamp.toDate();
  }

Future<DateTime?> getWBCurrentExpiryDate(String uid) async {
    QuestionnaireNotification? currentQuestionnaire =
        await getOngoingQuestionnaireNotification(uid, QuestionnaireNotificationTypes.WB_COMPLETE);

    if (currentQuestionnaire == null) {
      return null;
    }
    return currentQuestionnaire.expiryTimestamp.toDate();
  }

  Future<bool> questionnaireUpdateRequired(
      QuestionnaireNotification notification) async {
    try {
      QuestionnaireNotification? qn =
          await getFBQuestionnaireNotificationScheduledNext(notification.uid);
      if (qn != null) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error sending notification');
      return false;
    }
  }

  Future<bool> checkIfCollectionExist(String uid, String collectionName) async {
    try {
      var value = await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .collection(collectionName)
          .limit(1)
          .get();
      // print("$uid: ${value.docs.isNotEmpty}");
      return value.docs.isNotEmpty;
    } catch (e) {
      // print("$uid: false");
      return false;
    }
  }

  Timestamp setExpiryTimestamp(Timestamp start, int numMonthsToExpiry) {
    // Get the current date and time
    DateTime startDt = start.toDate();

    // Add six months to the current date and time
    DateTime expiryDateTime =
        startDt.add(Duration(days: numMonthsToExpiry * 30)); // Assuming 30 days per month

    // Convert the expiryDateTime to a Firestore Timestamp
    Timestamp expiryTimestamp = Timestamp.fromDate(expiryDateTime);
    return expiryTimestamp;
    // Now you can use the expiryTimestamp as needed
  }

  Future<CompleteProgressDTO> getMockCompletionProgress(
      ResultType timeAgo, User user) async {
    /* Based off a certain qnid - 
     1. Latest is the most recent qnid 
     2. 6 months ago implies qnid which is closest (>=6 months)*/

    /* steps 
     1. Go db and find QNID which is closest to timeAgo
     2. Go through every user and their QuestionAnswer collection (in their doc - for some users this may not exist)
     3. Count number of QuestionAnswers they have for that QNID and see if this number matches the number of Questions in the db
     4. If it matches then add to completed and total. Or else, if it is less, just add to total and not completed
     */

    CompleteProgressDTO completeProgressDTO =
        CompleteProgressDTO(completed: 10, total: 350);

    return completeProgressDTO;
  }


  Future<CompleteProgressDTO> getCompletionProgressWB(ResultType timeAgo, User user){
    return getCompletionProgress(timeAgo, user, QuestionnaireNotificationTypes.WB_COMPLETE);
  }

 Future<CompleteProgressDTO> getCompletionProgressFB(ResultType timeAgo, User user){
    return getCompletionProgress(timeAgo, user, QuestionnaireNotificationTypes.FB_COMPLETE);
  }

  Future<CompleteProgressDTO> getCompletionProgress(
      ResultType timeAgo, User user, QuestionnaireNotificationTypes type) async {
    // Step 1: Find the QNID based on the ResultType
    String? qnid;
    DateTime now = DateTime.now();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('QuestionnaireNotification')
        .orderBy('startTimestamp', descending: true)
        .where('type', isEqualTo: type.toString().split('.').last)
        .get();

    List<QuestionnaireNotification> notifications = querySnapshot.docs
        .map((doc) => QuestionnaireNotification.fromDocumentSnapshot(doc))
        .toList();

    switch (timeAgo) {
      case ResultType.latest:
        // The most recent QNID is the first one in the list (since it's sorted in descending order)
        if (notifications.isNotEmpty) {
          qnid = notifications.first.qnid;
        }
        break;
      case ResultType.sixMonthsAgo:
        // Find the QNID closest to 6 months ago
        for (var notification in notifications) {
          if (notification.startTimestamp
              .toDate()
              .isBefore(now.subtract(Duration(days: 6 * 30)))) {
            qnid = notification.qnid;
            break;
          }
        }
        break;
      case ResultType.oneYearAgo:
        // Find the QNID closest to one year ago
        for (var notification in notifications) {
          if (notification.startTimestamp
              .toDate()
              .isBefore(now.subtract(Duration(days: 365)))) {
            qnid = notification.qnid;
            break;
          }
        }
        break;
    }
    // print("QNID IS $qnid");

    // Step 2: Access the QuestionAnswer data for all users and count completed questionnaires
    int completedCount = 0;
    int totalCount = 0;

    // Step 3: Identify totalQuestions -  For now assume all questions are for everyone
    QuestionCategory qtype = QuestionCategory.FOUNDATION_BUILDER;
    if(type == QuestionnaireNotificationTypes.WB_COMPLETE){
      qtype = QuestionCategory.WELLNESS_BUILDER;
    }

    QuerySnapshot questionsSnapshot = await FirebaseFirestore.instance
        .collection('Question')
        .where('category', isEqualTo: qtype.toString().split('.').last)
        .get();
    int totalQuestions = questionsSnapshot.docs.length;
    if(totalQuestions == 0){ // No questions exist
      return CompleteProgressDTO(completed: 0, total: 0);
    }
    print("TOTAL QUESTIONS = $totalQuestions");

    if (qnid != null) {
      print(qnid);
      // Query the collection to get all users
      QuerySnapshot userSnapshots = await FirebaseFirestore.instance
          .collection('User')
          .where('managerId', isEqualTo: user.uid)
          .get();
      totalCount = userSnapshots.docs.length;
      // print(totalCount);
      // Loop through each user to count completed questionnaires
      for (var userSnapshot in userSnapshots.docs) {
        // print("Relevant users :${userSnapshot["email"]}");
        bool collectionExists =
            (await checkIfCollectionExist(userSnapshot.id, 'QuestionAnswers'));
        if (collectionExists) {
          print("Relevant users with QnA:${userSnapshot["email"]}");

          //   // Get the 'QuestionAnswer' sub-collection for each user
          CollectionReference questionAnswersCollection = FirebaseFirestore
              .instance
              .collection('User')
              .doc(userSnapshot.id)
              .collection('QuestionAnswers');

        // Get the documents in the 'QuestionAnswers' subcollection
          QuerySnapshot questionAnswersQuerySnapshot =
              await questionAnswersCollection.get();

        // Convert the documents to a list of 'QuestionAnswer' objects
          List<QuestionAnswer> questionAnswers = questionAnswersQuerySnapshot
              .docs
              .map((doc) => QuestionAnswer.fromDocumentSnapshot(doc))
              .toList();

          // Count completed and total for each user
        int totalCompleted = 0;
        for (var i in questionAnswers) {
            if (i.qnid == qnid) {
              print("User with answers:${userSnapshot["email"]}");
              // print(i.qnid); // Print the value of i.qnid
              totalCompleted++; // Increment the total count
            }
          }

          if (totalCompleted == totalQuestions) {
            print('User who has completed the questions: ${userSnapshot["email"]}');
            completedCount += 1;
          }
        }
      }
    }

    // Step 3: Create and return the CompleteProgressDTO
    CompleteProgressDTO completeProgressDTO =
        CompleteProgressDTO(completed: completedCount, total: totalCount);

    return completeProgressDTO;
  }

///////////////////////////////////////////////////////////////////////////////
  Future<bool> sendFBRemindNotification(User user) async {
    return sendRemindNotification(user, QuestionnaireNotificationTypes.FB_COMPLETE);
  }

   Future<bool> sendWBRemindNotification(User user) async {
    return sendRemindNotification(user, QuestionnaireNotificationTypes.WB_COMPLETE);
  }
 
  Future<bool> sendRemindNotification(User user, QuestionnaireNotificationTypes type) async {
    // Step 1: Find the QNID based on the ResultType
    String? qnid;
    Timestamp now = Timestamp.now();
    QuestionnaireNotification notifToRemind;
    bool sendNotification = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('QuestionnaireNotification')
        .where('type',
            isEqualTo: type
                .toString()
                .split('.')
                .last)
        .orderBy('startTimestamp', descending: true)
        .get();

    List<QuestionnaireNotification> notifications = querySnapshot.docs
        .map((doc) => QuestionnaireNotification.fromDocumentSnapshot(doc))
        .toList();

    if (notifications.isEmpty) {
      return false;
    }
    // The most recent QNID is the first one in the list (since it's sorted in descending order)
    notifToRemind = notifications.first;
    qnid = notifToRemind.qnid;

    print("QNID IS $qnid");

    // Step 2: Access the QuestionAnswer data for all users and count completed questionnaires
    // int totalCount = 0;

    // Step 3: Identify totalQuestions -  For now assume all questions are for everyone
    QuestionCategory qtype = QuestionCategory.FOUNDATION_BUILDER;
    if(type == QuestionnaireNotificationTypes.WB_COMPLETE){
      qtype = QuestionCategory.FOUNDATION_BUILDER;
    }

    QuerySnapshot questionsSnapshot = await FirebaseFirestore.instance
        .collection('Question')
        .where('category', isEqualTo: qtype
                .toString()
                .split('.')
                .last)
        .get();
    int totalQuestions = questionsSnapshot.docs.length;
    print("TOTAL QUESTIONS = $totalQuestions");

    // Query the collection to get all users
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance
        .collection('User')
        .where('managerId', isEqualTo: user.uid)
        .get();
    // totalCount = userSnapshots.docs.length;
    // Loop through each user to count completed questionnaires
    for (var userSnapshot in userSnapshots.docs) {
      // print("Relevant users :${userSnapshot["email"]}");
      // bool collectionExists =
      //     (await checkIfCollectionExist(userSnapshot.id, 'QuestionAnswers'));
      // if (collectionExists) {
      print("Relevant users with QnA:${userSnapshot["email"]}");

      //   // Get the 'QuestionAnswer' sub-collection for each user
      CollectionReference questionAnswersCollection = FirebaseFirestore.instance
          .collection('User')
          .doc(userSnapshot.id)
          .collection('QuestionAnswers');
      // Get the documents in the 'QuestionAnswers' subcollection
      QuerySnapshot questionAnswersQuerySnapshot =
          await questionAnswersCollection.get();
      // Convert the documents to a list of 'QuestionAnswer' objects
      List<QuestionAnswer> questionAnswers = questionAnswersQuerySnapshot.docs
          .map((doc) => QuestionAnswer.fromDocumentSnapshot(doc))
          .toList();

      // Count completed and total for each user
      int totalCompleted = questionAnswers.where((i) => i.qnid == qnid).length;

      if (totalCompleted != totalQuestions) {
        sendNotification = true;
      }
    }
    QuestionnaireNotificationTypes remindType = QuestionnaireNotificationTypes.FB_REMIND;
    if(type == QuestionnaireNotificationTypes.WB_COMPLETE){
      remindType = QuestionnaireNotificationTypes.WB_REMIND;
    }
    if (sendNotification) {
      try {
        QuestionnaireNotification notification = QuestionnaireNotification(
            qnid: qnid,
            startTimestamp: notifToRemind.startTimestamp,
            type: remindType,
            creationTimestamp: now,
            expiryTimestamp: notifToRemind.expiryTimestamp,
            uid: user.uid);
        createQuestionnaireNotification(notification);
      } catch (e) {
        print(e);
        return false;
      }
    }

    return true;
  }

  Future<bool> updateQuestionnaireNotification(
      String qnid, QuestionnaireNotification questionnaireNotification) async {
    try {
      final notificationQuery = FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .where('qnid', isEqualTo: qnid);

      final querySnapshot = await notificationQuery.get();

      if (querySnapshot.docs.isNotEmpty) {
        final notificationDoc = querySnapshot.docs.first;
        await notificationDoc.reference
            .update(questionnaireNotification.toMap());
        print('${questionnaireNotification.type} notification updated');
        return true;
      } else {
        print('No notification found with qnid: $qnid');
        return false;
      }
    } catch (e) {
      print('Error updating questionnaire notification: $e');
      return false;
    }
  }
}
