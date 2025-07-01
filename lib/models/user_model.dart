class UserModel {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final DateTime? quitDate;
  final int cigarettesPerDay;
  final double packPrice;
  final List<String> reasons;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    this.email,
    this.displayName,
    this.photoURL,
    this.quitDate,
    this.cigarettesPerDay = 20,
    this.packPrice = 5.0,
    this.reasons = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      quitDate: json['quitDate'] != null 
          ? DateTime.parse(json['quitDate'] as String)
          : null,
      cigarettesPerDay: json['cigarettesPerDay'] as int? ?? 20,
      packPrice: (json['packPrice'] as num?)?.toDouble() ?? 5.0,
      reasons: List<String>.from(json['reasons'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'quitDate': quitDate?.toIso8601String(),
      'cigarettesPerDay': cigarettesPerDay,
      'packPrice': packPrice,
      'reasons': reasons,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? quitDate,
    int? cigarettesPerDay,
    double? packPrice,
    List<String>? reasons,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      quitDate: quitDate ?? this.quitDate,
      cigarettesPerDay: cigarettesPerDay ?? this.cigarettesPerDay,
      packPrice: packPrice ?? this.packPrice,
      reasons: reasons ?? this.reasons,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 