class QuestionAndAnswerDTO {
  final String qid;
  final int answer;

  QuestionAndAnswerDTO({required this.qid, required this.answer});

  @override
  String toString() {
    return 'QuestionAndAnswerDTO{qid: $qid, answer: $answer}';
  }
}
