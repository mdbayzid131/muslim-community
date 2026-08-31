class AskQuestionModel {
  final String id;
  final String userId;
  final String userRole;
  final String title;
  final String question;
  final String category;
  final String status;
  final List<AnswerModel> answers;
  final String? answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  AskQuestionModel({
    required this.id,
    required this.userId,
    required this.userRole,
    this.title = '',
    required this.question,
    this.category = 'General',
    required this.status,
    required this.answers,
    this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AskQuestionModel.fromJson(Map<String, dynamic> json) {
    final ansList = (json['answers'] as List?)?.map((e) {
          if (e is String) {
            return AnswerModel(
              id: '',
              answer: e,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          } else if (e is Map) {
            return AnswerModel.fromJson(Map<String, dynamic>.from(e));
          } else {
            return AnswerModel(
              id: '',
              answer: e?.toString() ?? '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        }).toList() ??
        [];

    String? directAnswer = json['answer']?.toString();
    if ((directAnswer == null || directAnswer.isEmpty) && ansList.isNotEmpty) {
      directAnswer = ansList.first.answer;
    }

    return AskQuestionModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userRole: json['userRole']?.toString() ?? '',
      title: json['title']?.toString() ??
          json['subject']?.toString() ??
          json['topic']?.toString() ??
          'Question',
      question: json['question']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      status: json['status']?.toString() ?? 'pending',
      answers: ansList,
      answer: directAnswer,
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}

class AnswerModel {
  final String id;
  final String? questionId;
  final String answer;
  final String? answeredBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnswerModel({
    required this.id,
    this.questionId,
    required this.answer,
    this.answeredBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      questionId: json['questionId']?.toString(),
      answer: json['answer']?.toString() ??
          json['ans']?.toString() ??
          json['content']?.toString() ??
          json['text']?.toString() ??
          json['reply']?.toString() ??
          '',
      answeredBy: json['answeredBy']?.toString(),
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}
