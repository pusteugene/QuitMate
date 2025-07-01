import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorage = LocalStorageService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  // Геттеры
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Инициализация
  Future<void> init() async {
    await _localStorage.init();
    await _loadUser();
  }

  // Загрузка пользователя
  Future<void> _loadUser() async {
    _setLoading(true);
    
    try {
      // Сначала загружаем из локального хранилища
      final localUser = _localStorage.getUser();
      if (localUser != null) {
        _user = localUser;
        notifyListeners();
      }
      
      // Затем пытаемся синхронизировать с Firebase
      if (_user != null) {
        await _syncWithFirebase();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Синхронизация с Firebase
  Future<void> _syncWithFirebase() async {
    try {
      final firebaseUser = await _firestoreService.getUser(_user!.id);
      if (firebaseUser != null) {
        _user = firebaseUser;
        await _localStorage.saveUser(_user!);
        notifyListeners();
      } else {
        // Создаем пользователя в Firebase
        await _firestoreService.createUser(_user!);
      }
    } catch (e) {
      print('Ошибка синхронизации с Firebase: $e');
      // Продолжаем работу с локальными данными
    }
  }

  // Установка даты отказа от курения
  Future<bool> setQuitDate(DateTime quitDate) async {
    if (_user == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedUser = _user!.copyWith(
        quitDate: quitDate,
        updatedAt: DateTime.now(),
      );
      
      _user = updatedUser;
      await _localStorage.saveUser(_user!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.updateUser(_user!);
      } catch (e) {
        print('Ошибка синхронизации с Firebase: $e');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Обновление настроек курения
  Future<bool> updateSmokingSettings({
    int? cigarettesPerDay,
    double? packPrice,
  }) async {
    if (_user == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedUser = _user!.copyWith(
        cigarettesPerDay: cigarettesPerDay ?? _user!.cigarettesPerDay,
        packPrice: packPrice ?? _user!.packPrice,
        updatedAt: DateTime.now(),
      );
      
      _user = updatedUser;
      await _localStorage.saveUser(_user!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.updateUser(_user!);
      } catch (e) {
        print('Ошибка синхронизации с Firebase: $e');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Добавление причин отказа от курения
  Future<bool> addReason(String reason) async {
    if (_user == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedReasons = List<String>.from(_user!.reasons)..add(reason);
      final updatedUser = _user!.copyWith(
        reasons: updatedReasons,
        updatedAt: DateTime.now(),
      );
      
      _user = updatedUser;
      await _localStorage.saveUser(_user!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.updateUser(_user!);
      } catch (e) {
        print('Ошибка синхронизации с Firebase: $e');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Удаление причины
  Future<bool> removeReason(String reason) async {
    if (_user == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedReasons = List<String>.from(_user!.reasons)..remove(reason);
      final updatedUser = _user!.copyWith(
        reasons: updatedReasons,
        updatedAt: DateTime.now(),
      );
      
      _user = updatedUser;
      await _localStorage.saveUser(_user!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.updateUser(_user!);
      } catch (e) {
        print('Ошибка синхронизации с Firebase: $e');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Обновление пользователя
  Future<bool> updateUser(UserModel user) async {
    _setLoading(true);
    _error = null;
    
    try {
      _user = user;
      await _localStorage.saveUser(_user!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.updateUser(_user!);
      } catch (e) {
        print('Ошибка синхронизации с Firebase: $e');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Получение статистики
  Map<String, dynamic> getStats() {
    if (_user?.quitDate == null) {
      return {
        'daysSmokeFree': 0,
        'cigarettesAvoided': 0,
        'moneySaved': 0.0,
        'healthStage': 'Не установлена дата отказа',
      };
    }

    final now = DateTime.now();
    final quitDate = _user!.quitDate!;
    final daysSmokeFree = now.difference(quitDate).inDays;
    
    final cigarettesPerDay = _user!.cigarettesPerDay;
    final cigarettesAvoided = daysSmokeFree * cigarettesPerDay;
    
    final packPrice = _user!.packPrice;
    final cigarettesPerPack = 20; // Стандартное количество сигарет в пачке
    final moneySaved = (cigarettesAvoided / cigarettesPerPack) * packPrice;
    
    final healthStage = _getHealthStage(daysSmokeFree);
    
    return {
      'daysSmokeFree': daysSmokeFree,
      'cigarettesAvoided': cigarettesAvoided,
      'moneySaved': moneySaved,
      'healthStage': healthStage,
    };
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

  // Установка пользователя (для AuthProvider)
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Очистка пользователя
  void clearUser() {
    _user = null;
    notifyListeners();
  }
} 