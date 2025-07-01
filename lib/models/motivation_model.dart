class MotivationModel {
  final String id;
  final String userId;
  final String type; // 'quote' или 'reason'
  final String content;
  final String? author;
  final DateTime createdAt;
  final bool isActive;

  MotivationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    this.author,
    required this.createdAt,
    this.isActive = true,
  });

  factory MotivationModel.fromJson(Map<String, dynamic> json) {
    return MotivationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      author: json['author'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  MotivationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? content,
    String? author,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return MotivationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      content: content ?? this.content,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class DailyQuote {
  final String id;
  final String content;
  final String author;
  final String category;
  final DateTime date;

  DailyQuote({
    required this.id,
    required this.content,
    required this.author,
    required this.category,
    required this.date,
  });

  factory DailyQuote.fromJson(Map<String, dynamic> json) {
    return DailyQuote(
      id: json['id'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'category': category,
      'date': date.toIso8601String(),
    };
  }
} 