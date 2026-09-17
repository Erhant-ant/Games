enum QuestionCategory {
  history,
  geography,
  literature,
  currentAffairs,
  health,
  cinema,
  sports,
  mixed,
}

extension QuestionCategoryExtension on QuestionCategory {
  String get name {
    switch (this) {
      case QuestionCategory.history:
        return "Tarih";
      case QuestionCategory.geography:
        return "Coğrafya";
      case QuestionCategory.literature:
        return "Edebiyat";
      case QuestionCategory.currentAffairs:
        return "Güncel Bilgiler";
      case QuestionCategory.health:
        return "Sağlık & İnsan";
      case QuestionCategory.cinema:
        return "Sinema";
      case QuestionCategory.sports:
        return "Spor";
      case QuestionCategory.mixed:
        return "Karışık";
    }
  }
}

class Question {
  final int id;
  final String text;
  final String answer;
  final String startingLetter;
  final QuestionCategory category;

  const Question({
    required this.id,
    required this.text,
    required this.answer,
    required this.startingLetter,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      answer: json['answer'] as String,
      startingLetter: json['startingLetter'] as String,
      category: QuestionCategory.values.firstWhere(
        (e) => e.toString() == 'QuestionCategory.${json['category']}',
        orElse: () => QuestionCategory.mixed,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'answer': answer,
      'startingLetter': startingLetter,
      'category': category.toString().split('.').last,
    };
  }
}
