# QuitMate - Приложение для отказа от курения

QuitMate - это Flutter-приложение, которое помогает пользователям бросить курить, отслеживая прогресс, предоставляя мотивацию и поддержку в трудные моменты.

## 🚀 Возможности

- **Отслеживание прогресса**: Календарь бросания, статистика дней без курения
- **Мотивация**: Ежедневные цитаты и персональные причины отказа
- **Поддержка при тяге**: Дыхательная практика и советы
- **Достижения**: Система достижений за различные этапы
- **Графики**: Визуализация прогресса и экономии
- **Офлайн-режим**: Работа без интернета с синхронизацией
- **Мультиязычность**: Поддержка русского и английского языков
- **Авторизация**: Вход через Google и email/password

## 📱 Поддерживаемые платформы

- Android
- iOS  
- Web (Flutter Web)

## 🛠 Технологии

- **Flutter** 3.0+
- **Firebase** (Auth, Firestore)
- **Provider** (State Management)
- **easy_localization** (Локализация)
- **shared_preferences** (Локальное хранение)
- **fl_chart** (Графики)

## 📋 Требования

- Flutter SDK 3.0.0 или выше
- Dart 3.0.0 или выше
- Android Studio / VS Code
- Firebase проект

## 🔧 Установка и настройка

### 1. Клонирование репозитория

```bash
git clone <repository-url>
cd quitmate
```

### 2. Установка зависимостей

```bash
flutter pub get
```

### 3. Настройка Firebase

#### Создание проекта Firebase

1. Перейдите на [Firebase Console](https://console.firebase.google.com/)
2. Создайте новый проект
3. Включите Authentication и выберите методы:
   - Email/Password
   - Google Sign-In
4. Создайте Firestore Database

#### Настройка для Android

1. В Firebase Console добавьте Android приложение
2. Скачайте `google-services.json` и поместите в `android/app/`
3. Обновите `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

4. Обновите `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

#### Настройка для iOS

1. В Firebase Console добавьте iOS приложение
2. Скачайте `GoogleService-Info.plist` и добавьте в Xcode проект
3. Обновите `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

#### Настройка для Web

1. В Firebase Console добавьте Web приложение
2. Скопируйте конфигурацию и создайте файл `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // Добавьте другие платформы при необходимости
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'your-api-key',
    appId: 'your-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
  );
}
```

### 4. Настройка Google Sign-In

#### Для Android

Добавьте SHA-1 отпечаток в Firebase Console:
```bash
cd android
./gradlew signingReport
```

#### Для iOS

Настройте URL схемы в Xcode для Google Sign-In.

### 5. Запуск приложения

```bash
# Для Android
flutter run

# Для iOS
flutter run

# Для Web
flutter run -d chrome
```

## 📁 Структура проекта

```
lib/
├── main.dart                 # Точка входа
├── app.dart                  # Основное приложение
├── models/                   # Модели данных
│   ├── user_model.dart
│   ├── progress_model.dart
│   ├── motivation_model.dart
│   └── settings_model.dart
├── providers/                # Провайдеры состояния
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   ├── progress_provider.dart
│   └── settings_provider.dart
├── services/                 # Сервисы
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── local_storage_service.dart
├── screens/                  # Экраны
│   ├── onboarding_screen.dart
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   ├── progress_screen.dart
│   ├── motivation_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Виджеты
│   └── craving_modal.dart
└── localization/             # Локализация
    ├── en.json
    └── ru.json
```

## 🔐 Безопасность

- Все данные пользователей шифруются
- Аутентификация через Firebase Auth
- Локальное хранение с шифрованием
- Синхронизация только при наличии интернета

## 📊 Функции

### Главный экран
- Отображение статистики (дни без курения, сэкономленные деньги)
- Кнопка "Тяга" с дыхательной практикой
- Быстрые действия (установка даты отказа, добавление причин)

### Прогресс
- Календарь бросания
- Система достижений
- Графики прогресса

### Мотивация
- Ежедневные цитаты
- Персональные причины отказа от курения

### Настройки
- Язык и тема
- Параметры курения
- Уведомления

## 🚀 Развертывание

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции
3. Внесите изменения
4. Создайте Pull Request

## 📄 Лицензия

Этот проект лицензирован под MIT License.

## 📞 Поддержка

Если у вас есть вопросы или проблемы, создайте Issue в репозитории.

## 🔄 Обновления

Следите за обновлениями в репозитории для получения новых функций и исправлений ошибок. 