import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocalStorageService _localStorage = LocalStorageService();
  
  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  bool _isFirstLaunch = true;

  // Геттеры
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  bool get isFirstLaunch => _isFirstLaunch;

  // Инициализация
  Future<void> init() async {
    await _localStorage.init();
    await _checkAuthState();
    await _checkFirstLaunch();
  }

  // Проверка состояния аутентификации
  Future<void> _checkAuthState() async {
    _setLoading(true);
    
    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        // Пользователь уже авторизован
        final userData = await _localStorage.getUser();
        if (userData != null) {
          _user = userData;
          _isAuthenticated = true;
        } else {
          // Создаем пользователя из Firebase Auth
          _user = UserModel(
            id: currentUser.uid,
            email: currentUser.email,
            displayName: currentUser.displayName,
            photoURL: currentUser.photoURL,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _localStorage.saveUser(_user!);
          _isAuthenticated = true;
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Проверка первого запуска
  Future<void> _checkFirstLaunch() async {
    try {
      final isFirstLaunch = await _localStorage.isFirstLaunch();
      _isFirstLaunch = isFirstLaunch;
    } catch (e) {
      _isFirstLaunch = true;
    }
  }

  // Вход через Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _error = null;
    
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        _user = user;
        _isAuthenticated = true;
        await _localStorage.saveUser(_user!);
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

  // Регистрация через email
  Future<bool> signUpWithEmail(String email, String password, String displayName) async {
    _setLoading(true);
    _error = null;
    
    try {
      final user = await _authService.signUpWithEmail(email, password, displayName);
      if (user != null) {
        _user = user;
        _isAuthenticated = true;
        await _localStorage.saveUser(_user!);
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

  // Вход через email
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _error = null;
    
    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        _user = user;
        _isAuthenticated = true;
        await _localStorage.saveUser(_user!);
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

  // Сброс пароля
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Выход
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _authService.signOut();
      _user = null;
      _isAuthenticated = false;
      await _localStorage.clearUser();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Установка первого запуска
  Future<void> setFirstLaunch(bool value) async {
    _isFirstLaunch = value;
    await _localStorage.setFirstLaunch(value);
    notifyListeners();
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

  // Обновление профиля
  Future<bool> updateProfile({String? displayName, String? photoURL}) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _authService.updateProfile(displayName: displayName, photoURL: photoURL);
      
      if (_user != null) {
        _user = _user!.copyWith(
          displayName: displayName ?? _user!.displayName,
          photoURL: photoURL ?? _user!.photoURL,
          updatedAt: DateTime.now(),
        );
        await _localStorage.saveUser(_user!);
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Обновление пользователя
  Future<void> updateUser(UserModel user) async {
    _user = user;
    await _localStorage.saveUser(user);
    notifyListeners();
  }
} 