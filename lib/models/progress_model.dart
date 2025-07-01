class ProgressModel {
  final String id;
  final String userId;
  final DateTime date;
  final int daysSmokeFree;
  final int cigarettesAvoided;
  final double moneySaved;
  final String healthStage;
  final bool isAchievementUnlocked;
  final List<String> achievements;
  final DateTime createdAt;

  ProgressModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.daysSmokeFree,
    required this.cigarettesAvoided,
    required this.moneySaved,
    required this.healthStage,
    this.isAchievementUnlocked = false,
    this.achievements = const [],
    required this.createdAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      daysSmokeFree: json['daysSmokeFree'] as int,
      cigarettesAvoided: json['cigarettesAvoided'] as int,
      moneySaved: (json['moneySaved'] as num).toDouble(),
      healthStage: json['healthStage'] as String,
      isAchievementUnlocked: json['isAchievementUnlocked'] as bool? ?? false,
      achievements: List<String>.from(json['achievements'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'daysSmokeFree': daysSmokeFree,
      'cigarettesAvoided': cigarettesAvoided,
      'moneySaved': moneySaved,
      'healthStage': healthStage,
      'isAchievementUnlocked': isAchievementUnlocked,
      'achievements': achievements,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProgressModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? daysSmokeFree,
    int? cigarettesAvoided,
    double? moneySaved,
    String? healthStage,
    bool? isAchievementUnlocked,
    List<String>? achievements,
    DateTime? createdAt,
  }) {
    return ProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      daysSmokeFree: daysSmokeFree ?? this.daysSmokeFree,
      cigarettesAvoided: cigarettesAvoided ?? this.cigarettesAvoided,
      moneySaved: moneySaved ?? this.moneySaved,
      healthStage: healthStage ?? this.healthStage,
      isAchievementUnlocked: isAchievementUnlocked ?? this.isAchievementUnlocked,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final int daysRequired;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.daysRequired,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      daysRequired: json['daysRequired'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'daysRequired': daysRequired,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
} 