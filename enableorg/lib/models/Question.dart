// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionCategory { FOUNDATION_BUILDER, WELLNESS_BUILDER }

enum QuestionType {
  PUL11,
  PUL12,
  PUL13,
  PUL14,
  PUL15,
  PUL16,
  PUL17,
  PUL18,
  PUL19,
  PUL21,
  PUL22,
  PUL23,
  PUL24,
  PUL25,
  PUL26,
  PUL27,
  PUL28,
  PUL29,
  PUL31,
  PUL32,
  PUL33,
  PUL34,
  PUL35,
  PUL36,
  PUL37,
  PUL38,
  PUL39,
  PUL41,
  PUL42,
  PUL43,
  PUL44,
  PUL45,
  PUL46,
  PUL47,
  PUL48,
  PUL49,
  PUL51,
  PUL52,
  PUL53,
  PUL54,
  PUL55,
  PUL56,
  PUL57,
  PUL58,
  PUL59,
  PRC011,
  PRC012,
  PRC013,
  PRC021,
  PRC022,
  PRC023,
  PRC031,
  PRC032,
  PRC033,
  PRC041,
  PRC042,
  PRC043,
  PRC051,
  PRC052,
  PRC053,
  PRC061,
  PRC062,
  PRC063,
  PRC071,
  PRC072,
  PRC073,
  PRC081,
  PRC082,
  PRC083,
  PRC091,
  PRC092,
  PRC093,
  PRC101,
  PRC102,
  PRC103,
  PRC111,
  PRC112,
  PRC113,
  PRC121,
  PRC122,
  PRC123,
  CWB11,
  CWB12,
  CWB13,
  CWB14,
  CWB15,
  CWB21,
  CWB22,
  CWB23,
  CWB24,
  CWB25,
  CWB31,
  CWB32,
  CWB33,
  CWB34,
  CWB35,
  CWB41,
  CWB42,
  CWB43,
  CWB44,
  CWB45,
  CWB51,
  CWB52,
  CWB53,
  CWB61,
  CWB62,
  CWB63
}

class Question {
  final String qid;
  final String question;
  final QuestionCategory category;
  final QuestionType type;
  final Timestamp creationTimestamp;
  final String component;

  Question(
      {required this.question,
      required this.qid,
      required this.category,
      required this.type,
      required this.creationTimestamp,
      required this.component});

  factory Question.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final qid = snapshot.id;
    final categoryString = data['category'] as String;
    final typeString = data['type'] as String;
    final creationTimestamp = data['creationTimestamp'] as Timestamp;
    final question = data['question'] as String;
    final component = data['component'] as String;

    final category = _mapStringToQuestionCategory(categoryString);
    final type = _mapStringToQuestionType(typeString);

    return Question(
        question: question,
        qid: qid,
        category: category,
        type: type,
        creationTimestamp: creationTimestamp,
        component: component);
  }

  static Future<List<Question>> getQuestions() async {
    try {
       QuerySnapshot questionSnapshot =
          await FirebaseFirestore.instance.collection('Question').get();

      return questionSnapshot.docs.map((doc) {
        return Question.fromDocumentSnapshot(doc);
      }).toList();
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'qid': qid,
      'category': category.toString().split('.').last,
      'type': type.toString().split('.').last,
      'creationTimestamp': creationTimestamp,
      'component': component,
    };
  }

  static QuestionCategory _mapStringToQuestionCategory(String categoryString) {
    switch (categoryString) {
      case 'FOUNDATION_BUILDER':
        return QuestionCategory.FOUNDATION_BUILDER;
      case 'WELLNESS_BUILDER':
        return QuestionCategory.WELLNESS_BUILDER;
      default:
        throw Exception('Invalid category string: $categoryString');
    }
  }

  static QuestionType _mapStringToQuestionType(String typeString) {
    switch (typeString) {
      case 'PRC011':
        return QuestionType.PRC011;
      case 'PRC012':
        return QuestionType.PRC012;
      case 'PRC013':
        return QuestionType.PRC013;
      case 'PRC021':
        return QuestionType.PRC021;
      case 'PRC022':
        return QuestionType.PRC022;
      case 'PRC023':
        return QuestionType.PRC023;
      case 'PRC031':
        return QuestionType.PRC031;
      case 'PRC032':
        return QuestionType.PRC032;
      case 'PRC033':
        return QuestionType.PRC033;
      case 'PRC041':
        return QuestionType.PRC041;
      case 'PRC042':
        return QuestionType.PRC042;
      case 'PRC043':
        return QuestionType.PRC043;
      case 'PRC051':
        return QuestionType.PRC051;
      case 'PRC052':
        return QuestionType.PRC052;
      case 'PRC053':
        return QuestionType.PRC053;
      case 'PRC061':
        return QuestionType.PRC061;
      case 'PRC062':
        return QuestionType.PRC062;
      case 'PRC063':
        return QuestionType.PRC063;
      case 'PRC071':
        return QuestionType.PRC071;
      case 'PRC072':
        return QuestionType.PRC072;
      case 'PRC073':
        return QuestionType.PRC073;
      case 'PRC081':
        return QuestionType.PRC081;
      case 'PRC082':
        return QuestionType.PRC082;
      case 'PRC083':
        return QuestionType.PRC083;

      case 'PRC091':
        return QuestionType.PRC091;
      case 'PRC092':
        return QuestionType.PRC092;
      case 'PRC093':
        return QuestionType.PRC093;
      case 'PRC101':
        return QuestionType.PRC101;
      case 'PRC102':
        return QuestionType.PRC102;
      case 'PRC103':
        return QuestionType.PRC103;
      case 'PRC111':
        return QuestionType.PRC111;
      case 'PRC112':
        return QuestionType.PRC112;
      case 'PRC113':
        return QuestionType.PRC113;
      case 'PRC121':
        return QuestionType.PRC121;
      case 'PRC122':
        return QuestionType.PRC122;
      case 'PRC123':
        return QuestionType.PRC123;
      case 'CWB11':
        return QuestionType.CWB11;
      case 'CWB12':
        return QuestionType.CWB12;
      case 'CWB13':
        return QuestionType.CWB13;
      case 'CWB14':
        return QuestionType.CWB14;
      case 'CWB15':
        return QuestionType.CWB14;
      case 'CWB21':
        return QuestionType.CWB21;
      case 'CWB22':
        return QuestionType.CWB22;
      case 'CWB23':
        return QuestionType.CWB23;
      case 'CWB24':
        return QuestionType.CWB24;
      case 'CWB25':
        return QuestionType.CWB25;
      case 'CWB31':
        return QuestionType.CWB31;
      case 'CWB32':
        return QuestionType.CWB32;
      case 'CWB33':
        return QuestionType.CWB33;
      case 'CWB34':
        return QuestionType.CWB34;
      case 'CWB35':
        return QuestionType.CWB35;
      case 'CWB41':
        return QuestionType.CWB41;
      case 'CWB42':
        return QuestionType.CWB42;
      case 'CWB43':
        return QuestionType.CWB43;
      case 'CWB44':
        return QuestionType.CWB44;
      case 'CWB45':
        return QuestionType.CWB45;
      case 'CWB51':
        return QuestionType.CWB51;
      case 'CWB52':
        return QuestionType.CWB52;
      case 'CWB53':
        return QuestionType.CWB53;
      case 'CWB61':
        return QuestionType.CWB61;
      case 'CWB62':
        return QuestionType.CWB62;
      case 'CWB63':
        return QuestionType.CWB63;
      case 'PUL11':
        return QuestionType.PUL11;
      case 'PUL12':
        return QuestionType.PUL12;
      case 'PUL13':
        return QuestionType.PUL13;
      case 'PUL14':
        return QuestionType.PUL14;
      case 'PUL15':
        return QuestionType.PUL15;
      case 'PUL16':
        return QuestionType.PUL16;
      case 'PUL17':
        return QuestionType.PUL17;
      case 'PUL18':
        return QuestionType.PUL18;
      case 'PUL19':
        return QuestionType.PUL19;
      case 'PUL21':
        return QuestionType.PUL21;
      case 'PUL22':
        return QuestionType.PUL22;
      case 'PUL23':
        return QuestionType.PUL23;
      case 'PUL24':
        return QuestionType.PUL24;
      case 'PUL25':
        return QuestionType.PUL25;
      case 'PUL26':
        return QuestionType.PUL26;
      case 'PUL27':
        return QuestionType.PUL27;
      case 'PUL28':
        return QuestionType.PUL28;
      case 'PUL29':
        return QuestionType.PUL29;
      case 'PUL31':
        return QuestionType.PUL31;
      case 'PUL32':
        return QuestionType.PUL32;
      case 'PUL33':
        return QuestionType.PUL33;
      case 'PUL34':
        return QuestionType.PUL34;
      case 'PUL35':
        return QuestionType.PUL35;
      case 'PUL36':
        return QuestionType.PUL36;
      case 'PUL37':
        return QuestionType.PUL37;
      case 'PUL38':
        return QuestionType.PUL38;
      case 'PUL39':
        return QuestionType.PUL39;
      case 'PUL41':
        return QuestionType.PUL41;
      case 'PUL42':
        return QuestionType.PUL42;
      case 'PUL43':
        return QuestionType.PUL43;
      case 'PUL44':
        return QuestionType.PUL44;
      case 'PUL45':
        return QuestionType.PUL45;
      case 'PUL46':
        return QuestionType.PUL46;
      case 'PUL47':
        return QuestionType.PUL47;
      case 'PUL48':
        return QuestionType.PUL48;
      case 'PUL49':
        return QuestionType.PUL49;
      case 'PUL51':
        return QuestionType.PUL51;
      case 'PUL52':
        return QuestionType.PUL52;
      case 'PUL53':
        return QuestionType.PUL53;
      case 'PUL54':
        return QuestionType.PUL53;
      case 'PUL55':
        return QuestionType.PUL55;
      case 'PUL56':
        return QuestionType.PUL56;
      case 'PUL57':
        return QuestionType.PUL57;
      case 'PUL58':
        return QuestionType.PUL58;
      case 'PUL59':
        return QuestionType.PUL59;
      default:
        throw Exception('Invalid question type string: $typeString');
    }
  }
}
