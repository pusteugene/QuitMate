# Настройка Firebase для QuitMate

Этот документ содержит подробные инструкции по настройке Firebase для приложения QuitMate.

## 1. Создание проекта Firebase

1. Перейдите на [Firebase Console](https://console.firebase.google.com/)
2. Нажмите "Создать проект"
3. Введите название проекта (например, "quitmate-app")
4. Выберите, включать ли Google Analytics (рекомендуется)
5. Нажмите "Создать проект"

## 2. Настройка Authentication

1. В левом меню выберите "Authentication"
2. Нажмите "Начать"
3. Перейдите на вкладку "Sign-in method"
4. Включите следующие провайдеры:

### Email/Password
- Нажмите "Email/Password"
- Включите "Email/Password"
- Включите "Email link (passwordless sign-in)" (опционально)
- Нажмите "Сохранить"

### Google Sign-In
- Нажмите "Google"
- Включите Google Sign-In
- Добавьте email поддержки
- Нажмите "Сохранить"

## 3. Настройка Firestore Database

1. В левом меню выберите "Firestore Database"
2. Нажмите "Создать базу данных"
3. Выберите "Начать в тестовом режиме" (для разработки)
4. Выберите ближайший регион (например, europe-west3)
5. Нажмите "Готово"

### Правила безопасности Firestore

Обновите правила безопасности в Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Пользователи могут читать и писать только свои данные
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Прогресс пользователя
    match /progress/{progressId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Мотивация пользователя
    match /motivation/{motivationId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Настройки пользователя
    match /settings/{settingsId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## 4. Настройка для Android

### 4.1 Добавление Android приложения

1. В Firebase Console нажмите на значок Android
2. Введите Android package name: `com.example.quitmate`
3. Введите название приложения: `QuitMate`
4. Нажмите "Зарегистрировать приложение"

### 4.2 Скачивание конфигурации

1. Скачайте файл `google-services.json`
2. Поместите его в папку `android/app/`

### 4.3 Обновление build.gradle

Обновите файл `android/build.gradle`:

```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.15' // Добавьте эту строку
    }
}
```

Обновите файл `android/app/build.gradle`:

```gradle
// В конце файла добавьте:
apply plugin: 'com.google.gms.google-services'
```

### 4.4 Получение SHA-1 отпечатка

Для Google Sign-In добавьте SHA-1 отпечаток в Firebase Console:

```bash
cd android
./gradlew signingReport
```

Скопируйте SHA-1 отпечаток и добавьте его в Firebase Console в настройках проекта.

## 5. Настройка для iOS

### 5.1 Добавление iOS приложения

1. В Firebase Console нажмите на значок iOS
2. Введите Bundle ID: `com.example.quitmate`
3. Введите название приложения: `QuitMate`
4. Нажмите "Зарегистрировать приложение"

### 5.2 Скачивание конфигурации

1. Скачайте файл `GoogleService-Info.plist`
2. Добавьте его в Xcode проект (перетащите в Runner)

### 5.3 Обновление Info.plist

Обновите файл `ios/Runner/Info.plist`:

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

Замените `YOUR_REVERSED_CLIENT_ID` на значение из `GoogleService-Info.plist`.

## 6. Настройка для Web

### 6.1 Добавление Web приложения

1. В Firebase Console нажмите на значок Web
2. Введите название приложения: `QuitMate Web`
3. Нажмите "Зарегистрировать приложение"

### 6.2 Обновление конфигурации

Обновите файл `lib/firebase_options.dart` с вашими данными:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-api-key',
  appId: 'your-actual-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  authDomain: 'your-actual-project-id.firebaseapp.com',
  storageBucket: 'your-actual-project-id.appspot.com',
);
```

## 7. Проверка настройки

После настройки проверьте, что все работает:

1. Запустите приложение: `flutter run`
2. Попробуйте зарегистрироваться через email
3. Попробуйте войти через Google
4. Проверьте, что данные сохраняются в Firestore

## 8. Переход в продакшн

Для продакшн версии:

1. Обновите правила безопасности Firestore
2. Настройте правильные домены для Web
3. Добавьте продакшн SHA-1 отпечатки для Android
4. Настройте правильные Bundle ID для iOS

## 9. Устранение неполадок

### Ошибка "Google Sign-In failed"
- Проверьте SHA-1 отпечаток в Firebase Console
- Убедитесь, что Google Sign-In включен в Authentication

### Ошибка "Firestore permission denied"
- Проверьте правила безопасности Firestore
- Убедитесь, что пользователь авторизован

### Ошибка "Firebase not initialized"
- Проверьте, что `firebase_options.dart` содержит правильные данные
- Убедитесь, что Firebase.initializeApp() вызывается в main()

## 10. Дополнительные ресурсы

- [Firebase Flutter документация](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/get-started) 