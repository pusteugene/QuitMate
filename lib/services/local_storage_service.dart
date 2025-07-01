import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/progress_model.dart';
import '../models/motivation_model.dart';
import '../models/settings_model.dart';

class LocalStorageService {
  static const String _userKey = 'user';
  static const String _progressKey = 'progress';
  static const String _motivationKey = 'motivation';
  static const String _settingsKey = 'settings';
  static const String _lastSyncKey = 'last_sync';
  static const String _isFirstLaunchKey = 'is_first_launch';

  late SharedPreferences _prefs;

  // Инициализация
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Пользователь
  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  // Прогресс
  Future<void> saveProgress(List<ProgressModel> progressList) async {
    final progressJson = progressList.map((p) => p.toJson()).toList();
    await _prefs.setString(_progressKey, jsonEncode(progressJson));
  }

  List<ProgressModel> getProgress() {
    final progressJson = _prefs.getString(_progressKey);
    if (progressJson != null) {
      final List<dynamic> jsonList = jsonDecode(progressJson);
      return jsonList.map((json) => ProgressModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> addProgress(ProgressModel progress) async {
    final progressList = getProgress();
    progressList.add(progress);
    await saveProgress(progressList);
  }

  // Мотивация
  Future<void> saveMotivation(List<MotivationModel> motivationList) async {
    final motivationJson = motivationList.map((m) => m.toJson()).toList();
    await _prefs.setString(_motivationKey, jsonEncode(motivationJson));
  }

  List<MotivationModel> getMotivation() {
    final motivationJson = _prefs.getString(_motivationKey);
    if (motivationJson != null) {
      final List<dynamic> jsonList = jsonDecode(motivationJson);
      return jsonList.map((json) => MotivationModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> addMotivation(MotivationModel motivation) async {
    final motivationList = getMotivation();
    motivationList.add(motivation);
    await saveMotivation(motivationList);
  }

  // Настройки
  Future<void> saveSettings(SettingsModel settings) async {
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  SettingsModel? getSettings() {
    final settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson != null) {
      return SettingsModel.fromJson(jsonDecode(settingsJson));
    }
    return null;
  }

  // Первый запуск
  Future<bool> isFirstLaunch() async {
    return _prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(_isFirstLaunchKey, value);
  }

  // Последняя синхронизация
  Future<void> setLastSync(DateTime dateTime) async {
    await _prefs.setString(_lastSyncKey, dateTime.toIso8601String());
  }

  DateTime? getLastSync() {
    final syncString = _prefs.getString(_lastSyncKey);
    if (syncString != null) {
      return DateTime.parse(syncString);
    }
    return null;
  }

  // Получение всех данных для синхронизации
  Map<String, dynamic> getAllDataForSync() {
    return {
      'user': getUser()?.toJson(),
      'progress': getProgress().map((p) => p.toJson()).toList(),
      'motivation': getMotivation().map((m) => m.toJson()).toList(),
      'settings': getSettings()?.toJson(),
      'lastSync': getLastSync()?.toIso8601String(),
    };
  }

  // Очистка всех данных
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Проверка наличия данных
  bool hasData() {
    return getUser() != null || getProgress().isNotEmpty || getMotivation().isNotEmpty;
  }

  // Получение статистики из локального хранилища
  Map<String, dynamic> getLocalStats() {
    final progressList = getProgress();
    
    if (progressList.isEmpty) {
      return {
        'totalDays': 0,
        'totalCigarettesAvoided': 0,
        'totalMoneySaved': 0.0,
        'currentStreak': 0,
      };
    }

    final latestProgress = progressList.first;
    
    return {
      'totalDays': latestProgress.daysSmokeFree,
      'totalCigarettesAvoided': latestProgress.cigarettesAvoided,
      'totalMoneySaved': latestProgress.moneySaved,
      'currentStreak': latestProgress.daysSmokeFree,
      'healthStage': latestProgress.healthStage,
    };
  }

  // Сохранение простых значений
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }
} 