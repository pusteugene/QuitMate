import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';
import '../models/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorage = LocalStorageService();
  
  SettingsModel? _settings;
  bool _isLoading = false;
  String? _error;

  // Геттеры
  SettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Инициализация
  Future<void> init() async {
    await _localStorage.init();
    await _loadSettings();
  }

  // Загрузка настроек
  Future<void> _loadSettings() async {
    _setLoading(true);
    
    try {
      // Загружаем из локального хранилища
      final localSettings = _localStorage.getSettings();
      if (localSettings != null) {
        _settings = localSettings;
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
      if (_settings != null) {
        final firebaseSettings = await _firestoreService.getSettings(_settings!.userId);
        if (firebaseSettings != null) {
          _settings = firebaseSettings;
          await _localStorage.saveSettings(_settings!);
          notifyListeners();
        } else {
          // Создаем настройки в Firebase
          await _firestoreService.saveSettings(_settings!);
        }
      }
    } catch (e) {
      print('Ошибка синхронизации настроек: $e');
    }
  }

  // Создание настроек по умолчанию
  Future<bool> createDefaultSettings(String userId) async {
    _setLoading(true);
    _error = null;
    
    try {
      final defaultSettings = SettingsModel(
        userId: userId,
        language: 'en',
        theme: 'system',
        notificationsEnabled: true,
        notificationTime: '09:00',
        cigarettesPerDay: 20,
        packPrice: 5.0,
        currency: 'USD',
        isFirstLaunch: true,
      );
      
      _settings = defaultSettings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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

  // Обновление языка
  Future<bool> updateLanguage(String language) async {
    if (_settings == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedSettings = _settings!.copyWith(language: language);
      _settings = updatedSettings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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

  // Обновление темы
  Future<bool> updateTheme(String theme) async {
    if (_settings == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedSettings = _settings!.copyWith(theme: theme);
      _settings = updatedSettings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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

  // Обновление настроек уведомлений
  Future<bool> updateNotificationSettings({
    bool? enabled,
    String? time,
  }) async {
    if (_settings == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedSettings = _settings!.copyWith(
        notificationsEnabled: enabled ?? _settings!.notificationsEnabled,
        notificationTime: time ?? _settings!.notificationTime,
      );
      _settings = updatedSettings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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
    String? currency,
  }) async {
    if (_settings == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedSettings = _settings!.copyWith(
        cigarettesPerDay: cigarettesPerDay ?? _settings!.cigarettesPerDay,
        packPrice: packPrice ?? _settings!.packPrice,
        currency: currency ?? _settings!.currency,
      );
      _settings = updatedSettings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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

  // Установка даты отказа
  Future<bool> setQuitDate(DateTime quitDate) async {
    if (_settings == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedSettings = _settings!.copyWith(quitDate: quitDate);
      _settings = updatedSettings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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

  // Установка первого запуска
  Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    if (_settings == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final updatedSettings = _settings!.copyWith(isFirstLaunch: isFirstLaunch);
      _settings = updatedSettings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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

  // Обновление всех настроек
  Future<bool> updateSettings(SettingsModel settings) async {
    _setLoading(true);
    _error = null;
    
    try {
      _settings = settings;
      await _localStorage.saveSettings(_settings!);
      
      // Синхронизация с Firebase
      try {
        await _firestoreService.saveSettings(_settings!);
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

  // Получение текущей темы
  ThemeMode getThemeMode() {
    if (_settings == null) return ThemeMode.system;
    
    switch (_settings!.theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Получение текущего языка
  String getCurrentLanguage() {
    return _settings?.language ?? 'en';
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

  // Установка настроек (для других провайдеров)
  void setSettings(SettingsModel settings) {
    _settings = settings;
    notifyListeners();
  }

  // Очистка настроек
  void clearSettings() {
    _settings = null;
    notifyListeners();
  }
} 