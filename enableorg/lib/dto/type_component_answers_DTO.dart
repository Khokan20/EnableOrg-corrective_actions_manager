import '../models/question.dart';

class TypeComponentAnswersDTO {
  final String? component;
  final QuestionType type;
  final List<int>? answers;

  TypeComponentAnswersDTO(
      {required this.component, required this.type, required this.answers});

  @override
  String toString() {
    return 'TypeComponentAnswersDTO(component: $component, type: $type, answers: $answers)\n\n';
  }
}
