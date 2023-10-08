import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enableorg/dto/question_and_answer_dto.dart';
import 'package:enableorg/dto/questions_and_identification_DTO.dart';
import 'package:enableorg/dto/time_result_types.dart';
import 'package:enableorg/dto/type_component_answers_DTO.dart';
import 'package:enableorg/models/question.dart';
import 'package:enableorg/models/question_answer.dart';
import 'package:enableorg/ui/circle_config.dart';

import '../../models/questionnaire_notifications.dart';
import '../../ui/circle_group.dart';

class ManagerHomeReportsController {
  /* Get's PRC config given the following parameters 
    1. UID of the manager - for recognising the managerId/company of Users 
    2. Department list - List of DIDs - recognise which users to query by department
    3. Location list - List of LIDs - recognise which users to query by sitelocation
    4. Date - Date of the report - ResultType Latest or 6 months ago or year ago
  */

  Map<String, List<int>> formatKeys(Map<String, List<int>> data) {
    Map<String, List<int>> formattedData = {};
    data.forEach((key, value) {
      if (key.length > 10) {
        final formattedKey = key.split(' ').join('\n');
        formattedData[formattedKey] = value;
      } else {
        formattedData[key] = value;
      }
    });
    return formattedData;
  }

  Future<CircleConfig?>? getPRCConfig() async {
    Map<String, List<int>>? averagedGroupMap =
        await getAveragesFoundationClimate(
            ResultType.latest,
            'klyW3TzL7uYRRkrRf9HMhhVzLKy1',
            QuestionnaireNotificationTypes.FB_COMPLETE);

    if (averagedGroupMap == null) {
      return null;
    }
    averagedGroupMap = formatKeys(averagedGroupMap);

    CircleConfig fbConfig = CircleConfig(groups: []);
    averagedGroupMap.forEach((component, values) {
      fbConfig.groups.add(CircleGroup(name: component, values: values));
    });
    print(averagedGroupMap);
    return fbConfig;
  }

  Future<CircleConfig?>? getPulseConfig() async {
    Map<String, List<int>>? averagedGroupMap =
        await getAveragesFoundationClimate(
            ResultType.latest,
            'klyW3TzL7uYRRkrRf9HMhhVzLKy1',
            QuestionnaireNotificationTypes.PUL_COMPLETE);
    if (averagedGroupMap == null) {
      return null;
    }
    averagedGroupMap = formatKeys(averagedGroupMap);

    CircleConfig pulConfig = CircleConfig(groups: []);
    averagedGroupMap.forEach((component, values) {
      pulConfig.groups.add(CircleGroup(name: component, values: values));
    });

    return pulConfig;
  }

  Future<CircleConfig?>? getWBConfig() async {
    Map<String, List<int>>? averagedGroupMap =
        await getAveragesFoundationClimate(
            ResultType.latest,
            'klyW3TzL7uYRRkrRf9HMhhVzLKy1',
            QuestionnaireNotificationTypes.WB_COMPLETE);
    if (averagedGroupMap == null) {
      return null;
    }
    averagedGroupMap = formatKeys(averagedGroupMap);
    CircleConfig wbConfig = CircleConfig(groups: []);
    averagedGroupMap.forEach((component, values) {
      wbConfig.groups.add(CircleGroup(name: component, values: values));
    });
    print(averagedGroupMap);
    return wbConfig;
  }

  /* retuns {component: values}
  ex. {PRC-A: [4, 4, 4], PRC-B: [3, 3, 3], PRC-C: [3, 3, 2], PRC-D: [4, 3, 3], PRC-E: [4, 5, 3]
  */
  Future<Map<String, List<int>>?> getAveragesFoundationClimate(
      ResultType periodResultType,
      String managerUID,
      QuestionnaireNotificationTypes type) async {
    //Convert to monhs ago
    final String? qnid = await getQnidByResultType(
        periodResultType, managerUID, type); //Change to parameter

    if (qnid == null) {
      return null;
    }

    final Map<String, List<QuestionAndAnswerDTO>> questionAnswersByQnid =
        await getQuestionAnswersByQnid(qnid);
    List<Question> questionsList = await Question.getQuestions();
    List<QuestionsAndIdentificationDTO> questionsAndIdentification =
        QuestionsAndIdentificationDTO.mapFromQuestions(questionsList);

    Map<String, TypeComponentAnswersDTO> questionAndAllAnswers = {};
    questionAnswersByQnid.forEach((user, questionAndAnswerList) {
      // Loop through each answer user has given
      for (var questionAndAnswer in questionAndAnswerList) {
        final qid = questionAndAnswer.qid;
        QuestionsAndIdentificationDTO? relevantQuestion;
        for (var question in questionsAndIdentification) {
          if (question.qid == qid) {
            relevantQuestion = question;
          }
        }
        if (relevantQuestion == null) {
          continue;
        }
        // If qid does not exist already in dictionary
        if (!questionAndAllAnswers.containsKey(qid)) {
          questionAndAllAnswers[qid] = TypeComponentAnswersDTO(
              component: relevantQuestion.component,
              type: relevantQuestion.type,
              answers: []);
        }
        // Append the data object to the list for the corresponding qid
        questionAndAllAnswers[qid]!.answers?.add(questionAndAnswer.answer);
      }
    });

    // Sort QuestionAnswerAll
    List<MapEntry<String, TypeComponentAnswersDTO>> sortedEntries =
        questionAndAllAnswers.entries.toList()
          ..sort((a, b) => a.value.type.index.compareTo(b.value.type.index));
    LinkedHashMap<String, TypeComponentAnswersDTO> sortedMap =
        LinkedHashMap.fromEntries(sortedEntries);

    Map<String, List<int>> averagedComponents =
        calculateComponentAverages(sortedMap);
    return averagedComponents;
  }

  Map<String, List<int>> calculateComponentAverages(
      Map<String, TypeComponentAnswersDTO> x) {
    // Create a map to store grouped components and their answers
    Map<String, List<int>> groupedComponents = {};

    // Iterate through the entries in the original map
    x.forEach((key, value) {
      String component = value.component!;
      int sum = 0;
      for (var answer in value.answers!) {
        sum += answer;
      }
      double average = sum / value.answers!.length;
      if (!groupedComponents.containsKey(component)) {
        groupedComponents[component] = [
          average.ceil()
        ]; // Take ceil as it indicates better
      } else {
        groupedComponents[component]!.add(average.ceil());
      }
    });

    return groupedComponents;
  }

  Future<Map<String, List<QuestionAndAnswerDTO>>> getQuestionAnswersByQnid(
      String qnid) async {
    try {
      // Initialize a map to store the results
      Map<String, List<QuestionAndAnswerDTO>> userQuestionAnswersMap = {};

      // Query the 'User' collection
      final QuerySnapshot userQuerySnapshot =
          await FirebaseFirestore.instance.collection('User').get();

      // Loop through each user document
      for (var userDoc in userQuerySnapshot.docs) {
        final userId = userDoc.id;

        // Query the 'QuestionAnswers' collection for the specific user and qnid
        final QuerySnapshot questionAnswersQuerySnapshot =
            await FirebaseFirestore.instance
                .collection('User')
                .doc(userId)
                .collection('QuestionAnswers')
                .where('qnid', isEqualTo: qnid)
                .get();

        // Check if any documents match the query
        if (questionAnswersQuerySnapshot.docs.isNotEmpty) {
          // Initialize a list to store QuestionAnswer elements for the user
          List<QuestionAndAnswerDTO> questionAnswersList = [];

          // Loop through the QuestionAnswers documents and add them to the list
          for (var questionAnswerDoc in questionAnswersQuerySnapshot.docs) {
            QuestionAnswer curQA =
                QuestionAnswer.fromDocumentSnapshot(questionAnswerDoc);
            questionAnswersList.add(
                QuestionAndAnswerDTO(answer: curQA.answer, qid: curQA.qid));
          }
          // Add the list to the userQuestionAnswersMap
          userQuestionAnswersMap[userId] = questionAnswersList;
        }
      }

      return userQuestionAnswersMap;
    } catch (e) {
      print("Error retrieving QuestionAnswers: $e");
      return {};
    }
  }

  static Future<String?> getQnidByResultType(ResultType timeAgo,
      String managerID, QuestionnaireNotificationTypes type) async {
    try {
      final now = DateTime.now();
      // Query for Questionnaire Notifications ordered by startTimestamp
      final querySnapshot = await FirebaseFirestore.instance
          .collection('QuestionnaireNotification')
          .orderBy('startTimestamp', descending: true)
          .where('uid', isEqualTo: managerID)
          .where('type', isEqualTo: type.toString().split('.').last)
          .get();

      final notifications = querySnapshot.docs
          .map((doc) => QuestionnaireNotification.fromDocumentSnapshot(doc))
          .toList();

      String? qnid;

      switch (timeAgo) {
        case ResultType.latest:
          if (notifications.isNotEmpty) {
            qnid = notifications.first.qnid;
          }
          break;
        case ResultType.sixMonthsAgo:
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

      return qnid;
    } catch (e) {
      print("Error getting qnid: $e");
      return null;
    }
  }
}
