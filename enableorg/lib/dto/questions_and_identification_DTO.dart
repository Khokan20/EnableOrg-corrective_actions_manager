import 'package:enableorg/models/question.dart';

class QuestionsAndIdentificationDTO {
  final String qid;
  final String component;
  final QuestionType type;
  final QuestionCategory category;

  QuestionsAndIdentificationDTO({
    required this.qid,
    required this.component,
    required this.type,
    required this.category,
  });

  // Mapper function to map List<Question> to List<QuestionsAndIdentificationDTO>
  static List<QuestionsAndIdentificationDTO> mapFromQuestions(
      List<Question> questions) {
    return questions.map((question) {
      return QuestionsAndIdentificationDTO(
        qid: question.qid,
        component: question.component,
        type: question.type, // Assuming type is an enum
        category: question.category, // Assuming category is an enum
      );
    }).toList();
  }

  @override
  String toString() {
    return 'QuestionsAndIdentificationDTO(qid: $qid, component: $component, type: $type, category: $category)';
  }
}
