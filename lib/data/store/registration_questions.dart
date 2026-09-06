import 'package:moftah/data/models/question_model.dart';

class RegistrationQuestions {
  RegistrationQuestions._();

  static final RegistrationQuestions instance = RegistrationQuestions._();

  static const List<QuestionModel> technicianQuestions = [
    QuestionModel(
      question: 'هل ممكن تطلع بره الورشة؟',
      answerYes: 'نعم',
      answerNo: 'لا',
    ),
    QuestionModel(
      question: 'هل عندك أدوات فحص إلكترونية؟',
      answerYes: 'متوفر',
      answerNo: 'غير متوفر',
    ),
    QuestionModel(
      question: 'هل تستقبل حالات طوارئ؟',
      answerYes: 'نعم',
      answerNo: 'لا',
    ),
  ];

  static const List<QuestionModel> driverQuestions = [
    QuestionModel(question: 'موديل عربيتك إيه؟'),
    QuestionModel(question: 'سنة تصنيع العربية كام؟'),
    QuestionModel(question: 'العربية ماشية كام كيلومتر؟'),
    QuestionModel(question: 'آخر مرة غيرت زيت المحرك كانت إمتى؟'),
    QuestionModel(
      question: 'عادةً بتغير زيت المحرك كل قد إيه؟',
      options: ['كل 3 شهور', 'كل 6 شهور', 'كل 9 شهور', 'كل 12 شهر'],
    ),
    QuestionModel(question: 'آخر مرة عملت صيانة دورية للعربية كانت إمتى؟'),
  ];
}
