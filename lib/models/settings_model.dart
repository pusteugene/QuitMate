class SettingsModel {
  final String userId;
  final String language; // 'en' или 'ru'
  final String theme; // 'light', 'dark', 'system'
  final bool notificationsEnabled;
  final String notificationTime; // '09:00', '12:00', etc.
  final int cigarettesPerDay;
  final double packPrice;
  final String currency; // 'USD', 'RUB', 'EUR'
  final DateTime? quitDate;
  final bool isFirstLaunch;

  SettingsModel({
    required this.userId,
    this.language = 'en',
    this.theme = 'system',
    this.notificationsEnabled = true,
    this.notificationTime = '09:00',
    this.cigarettesPerDay = 20,
    this.packPrice = 5.0,
    this.currency = 'USD',
    this.quitDate,
    this.isFirstLaunch = true,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      userId: json['userId'] as String,
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'system',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      notificationTime: json['notificationTime'] as String? ?? '09:00',
      cigarettesPerDay: json['cigarettesPerDay'] as int? ?? 20,
      packPrice: (json['packPrice'] as num?)?.toDouble() ?? 5.0,
      currency: json['currency'] as String? ?? 'USD',
      quitDate: json['quitDate'] != null 
          ? DateTime.parse(json['quitDate'] as String)
          : null,
      isFirstLaunch: json['isFirstLaunch'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'language': language,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime,
      'cigarettesPerDay': cigarettesPerDay,
      'packPrice': packPrice,
      'currency': currency,
      'quitDate': quitDate?.toIso8601String(),
      'isFirstLaunch': isFirstLaunch,
    };
  }

  SettingsModel copyWith({
    String? userId,
    String? language,
    String? theme,
    bool? notificationsEnabled,
    String? notificationTime,
    int? cigarettesPerDay,
    double? packPrice,
    String? currency,
    DateTime? quitDate,
    bool? isFirstLaunch,
  }) {
    return SettingsModel(
      userId: userId ?? this.userId,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      cigarettesPerDay: cigarettesPerDay ?? this.cigarettesPerDay,
      packPrice: packPrice ?? this.packPrice,
      currency: currency ?? this.currency,
      quitDate: quitDate ?? this.quitDate,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
} 