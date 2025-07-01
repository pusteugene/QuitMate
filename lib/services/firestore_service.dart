import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/progress_model.dart';
import '../models/motivation_model.dart';
import '../models/settings_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Коллекции
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _progress => _firestore.collection('progress');
  CollectionReference get _motivation => _firestore.collection('motivation');
  CollectionReference get _settings => _firestore.collection('settings');

  // Пользователи
  Future<void> createUser(UserModel user) async {
    try {
      await _users.doc(user.id).set(user.toJson());
    } catch (e) {
      print('Ошибка создания пользователя: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _users.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Ошибка получения пользователя: $e');
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _users.doc(user.id).update(user.toJson());
    } catch (e) {
      print('Ошибка обновления пользователя: $e');
      rethrow;
    }
  }

  // Прогресс
  Future<void> saveProgress(ProgressModel progress) async {
    try {
      await _progress.doc(progress.id).set(progress.toJson());
    } catch (e) {
      print('Ошибка сохранения прогресса: $e');
      rethrow;
    }
  }

  Future<List<ProgressModel>> getUserProgress(String userId) async {
    try {
      final querySnapshot = await _progress
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ProgressModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Ошибка получения прогресса: $e');
      return [];
    }
  }

  // Мотивация
  Future<void> saveMotivation(MotivationModel motivation) async {
    try {
      await _motivation.doc(motivation.id).set(motivation.toJson());
    } catch (e) {
      print('Ошибка сохранения мотивации: $e');
      rethrow;
    }
  }

  Future<List<MotivationModel>> getUserMotivation(String userId) async {
    try {
      final querySnapshot = await _motivation
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => MotivationModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Ошибка получения мотивации: $e');
      return [];
    }
  }

  // Настройки
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      await _settings.doc(settings.userId).set(settings.toJson());
    } catch (e) {
      print('Ошибка сохранения настроек: $e');
      rethrow;
    }
  }

  Future<SettingsModel?> getSettings(String userId) async {
    try {
      final doc = await _settings.doc(userId).get();
      if (doc.exists) {
        return SettingsModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Ошибка получения настроек: $e');
      return null;
    }
  }

  // Синхронизация данных
  Future<void> syncUserData(String userId, Map<String, dynamic> localData) async {
    try {
      final batch = _firestore.batch();
      
      // Синхронизация прогресса
      if (localData['progress'] != null) {
        for (var progressData in localData['progress']) {
          final progress = ProgressModel.fromJson(progressData);
          final docRef = _progress.doc(progress.id);
          batch.set(docRef, progress.toJson());
        }
      }

      // Синхронизация мотивации
      if (localData['motivation'] != null) {
        for (var motivationData in localData['motivation']) {
          final motivation = MotivationModel.fromJson(motivationData);
          final docRef = _motivation.doc(motivation.id);
          batch.set(docRef, motivation.toJson());
        }
      }

      await batch.commit();
    } catch (e) {
      print('Ошибка синхронизации: $e');
      rethrow;
    }
  }

  // Получение статистики
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final progressList = await getUserProgress(userId);
      
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
    } catch (e) {
      print('Ошибка получения статистики: $e');
      return {};
    }
  }
} 