import 'package:enableorg/models/question.dart';

class QuestionListAndQnidDTO {
  final List<Question> qList;
  final String? qnid;

  QuestionListAndQnidDTO({required this.qList, required this.qnid});
}
