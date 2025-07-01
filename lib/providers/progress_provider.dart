import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';
import '../models/progress_model.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';

class ProgressProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorage = LocalStorageService();
  
  List<ProgressModel> _progressList = [];
  List<Achievement> _achievements = [];
  bool _isLoading = false;
  String? _error;

  // Геттеры
  List<ProgressModel> get progressList => _progressList;
  List<Achievement> get achievements => _achievements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Инициализация
  Future<void> init() async {
    await _localStorage.init();
    await _loadProgress();
    _initializeAchievements();
  }

  // Загрузка прогресса
  Future<void> _loadProgress() async {
    _setLoading(true);
    
    try {
      // Загружаем из локального хранилища
      final localProgress = _localStorage.getProgress();
      if (localProgress.isNotEmpty) {
        _progressList = localProgress;
        notifyListeners();
      }
      
      // Синхронизируем с Firebase
      await _syncWithFirebase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Синхронизация с Firebase
  Future<void> _syncWithFirebase() async {
    try {
      // Получаем пользователя для синхронизации
      final user = _localStorage.getUser();
      if (user != null) {
        final firebaseProgress = await _firestoreService.getUserProgress(user.id);
        
        // Объединяем локальные и Firebase данные
        final allProgress = <ProgressModel>[];
        allProgress.addAll(_progressList);
        
        for (final progress in firebaseProgress) {
          if (!_progressList.any((p) => p.id == progress.id)) {
            allProgress.add(progress);
          }
        }
        
        _progressList = allProgress;
        await _localStorage.saveProgress(_progressList);
        notifyListeners();
      }
    } catch (e) {
      print('Ошибка синхронизации прогресса: $e');
    }
  }

  // Добавление нового прогресса
  Future<bool> addProgress(ProgressModel progress) async {
    _setLoading(true);
    _error = null;
    
    try {
      _progressList.add(progress);
      await _localStorage.saveProgress(_progressList);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveProgress(progress);
      } catch (e) {
        print('Ошибка синхронизации с Firebase: $e');
      }
      
      // Проверяем достижения
      await _checkAchievements(progress);
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Обновление прогресса
  Future<bool> updateProgress(ProgressModel progress) async {
    _setLoading(true);
    _error = null;
    
    try {
      final index = _progressList.indexWhere((p) => p.id == progress.id);
      if (index != -1) {
        _progressList[index] = progress;
        await _localStorage.saveProgress(_progressList);
        
        // Синхронизация с Firebase
        try {
          await _firestoreService.saveProgress(progress);
        } catch (e) {
          print('Ошибка синхронизации с Firebase: $e');
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Создание прогресса на основе пользователя
  Future<bool> createDailyProgress(UserModel user) async {
    if (user.quitDate == null) return false;
    
    final now = DateTime.now();
    final quitDate = user.quitDate!;
    final daysSmokeFree = now.difference(quitDate).inDays;
    
    final cigarettesAvoided = daysSmokeFree * user.cigarettesPerDay;
    final packPrice = user.packPrice;
    final cigarettesPerPack = 20;
    final moneySaved = (cigarettesAvoided / cigarettesPerPack) * packPrice;
    
    final healthStage = _getHealthStage(daysSmokeFree);
    
    final progress = ProgressModel(
      id: '${user.id}_${now.toIso8601String().split('T')[0]}',
      userId: user.id,
      date: now,
      daysSmokeFree: daysSmokeFree,
      cigarettesAvoided: cigarettesAvoided,
      moneySaved: moneySaved,
      healthStage: healthStage,
      createdAt: now,
    );
    
    return await addProgress(progress);
  }

  // Определение этапа восстановления здоровья
  String _getHealthStage(int days) {
    if (days < 1) return 'Начало пути';
    if (days < 3) return 'Первые дни';
    if (days < 7) return 'Неделя без курения';
    if (days < 14) return 'Две недели';
    if (days < 30) return 'Месяц без курения';
    if (days < 90) return 'Три месяца';
    if (days < 180) return 'Полгода';
    if (days < 365) return 'Год без курения';
    return 'Более года без курения';
  }

  // Инициализация достижений
  void _initializeAchievements() {
    _achievements = [
      Achievement(
        id: 'day_1',
        title: 'Первый день',
        description: 'Вы продержались один день без курения!',
        daysRequired: 1,
      ),
      Achievement(
        id: 'day_3',
        title: 'Три дня',
        description: 'Три дня без курения - отличное начало!',
        daysRequired: 3,
      ),
      Achievement(
        id: 'week_1',
        title: 'Неделя',
        description: 'Целая неделя без курения!',
        daysRequired: 7,
      ),
      Achievement(
        id: 'week_2',
        title: 'Две недели',
        description: 'Две недели без курения!',
        daysRequired: 14,
      ),
      Achievement(
        id: 'month_1',
        title: 'Месяц',
        description: 'Месяц без курения!',
        daysRequired: 30,
      ),
      Achievement(
        id: 'month_3',
        title: 'Три месяца',
        description: 'Три месяца без курения!',
        daysRequired: 90,
      ),
      Achievement(
        id: 'month_6',
        title: 'Полгода',
        description: 'Полгода без курения!',
        daysRequired: 180,
      ),
      Achievement(
        id: 'year_1',
        title: 'Год',
        description: 'Год без курения!',
        daysRequired: 365,
      ),
    ];
  }

  // Проверка достижений
  Future<void> _checkAchievements(ProgressModel progress) async {
    final daysSmokeFree = progress.daysSmokeFree;
    
    for (final achievement in _achievements) {
      if (!achievement.isUnlocked && daysSmokeFree >= achievement.daysRequired) {
        // Разблокируем достижение
        final unlockedAchievement = Achievement(
          id: achievement.id,
          title: achievement.title,
          description: achievement.description,
          daysRequired: achievement.daysRequired,
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        
        final index = _achievements.indexWhere((a) => a.id == achievement.id);
        if (index != -1) {
          _achievements[index] = unlockedAchievement;
        }
      }
    }
  }

  // Получение статистики
  Map<String, dynamic> getStats() {
    if (_progressList.isEmpty) {
      return {
        'totalDays': 0,
        'totalCigarettesAvoided': 0,
        'totalMoneySaved': 0.0,
        'currentStreak': 0,
        'healthStage': 'Нет данных',
      };
    }

    final latestProgress = _progressList.first;
    
    return {
      'totalDays': latestProgress.daysSmokeFree,
      'totalCigarettesAvoided': latestProgress.cigarettesAvoided,
      'totalMoneySaved': latestProgress.moneySaved,
      'currentStreak': latestProgress.daysSmokeFree,
      'healthStage': latestProgress.healthStage,
    };
  }

  // Получение прогресса за период
  List<ProgressModel> getProgressForPeriod(DateTime start, DateTime end) {
    return _progressList
        .where((progress) => 
            progress.date.isAfter(start.subtract(const Duration(days: 1))) &&
            progress.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  // Очистка ошибки
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Установка состояния загрузки
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Очистка данных
  void clearData() {
    _progressList.clear();
    _achievements.clear();
    notifyListeners();
  }
} 