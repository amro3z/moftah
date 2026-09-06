class QuestionModel {
  final String question;
  final String? answerYes;
  final String? answerNo;
  final String? answer;
  final List<String>? options;

  const QuestionModel({
    required this.question,
    this.answerYes,
    this.answerNo,
    this.answer,
    this.options,
  });
}
