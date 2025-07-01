import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/settings_provider.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _cigarettesController = TextEditingController();
  final _packPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _cigarettesController.dispose();
    _packPriceController.dispose();
    super.dispose();
  }

  void _loadSettings() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      if (settingsProvider.settings != null) {
        _cigarettesController.text = settingsProvider.settings!.cigarettesPerDay.toString();
        _packPriceController.text = settingsProvider.settings!.packPrice.toString();
      } else if (userProvider.user != null) {
        _cigarettesController.text = userProvider.user!.cigarettesPerDay.toString();
        _packPriceController.text = userProvider.user!.packPrice.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralSettings(),
            const SizedBox(height: 24),
            _buildSmokingSettings(),
            const SizedBox(height: 24),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final settings = settingsProvider.settings;
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Общие настройки',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLanguageSetting(settings),
                const SizedBox(height: 16),
                _buildThemeSetting(settings),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSetting(SettingsModel? settings) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Язык'),
      subtitle: Text(settings?.language == 'ru' ? 'Русский' : 'English'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showLanguageDialog(),
    );
  }

  Widget _buildThemeSetting(SettingsModel? settings) {
    String themeText = 'Системная';
    if (settings?.theme == 'light') themeText = 'Светлая';
    if (settings?.theme == 'dark') themeText = 'Тёмная';

    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Тема'),
      subtitle: Text(themeText),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showThemeDialog(),
    );
  }

  Widget _buildSmokingSettings() {
    return Consumer2<SettingsProvider, UserProvider>(
      builder: (context, settingsProvider, userProvider, _) {
        final settings = settingsProvider.settings;
        final user = userProvider.user;
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Настройки курения',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCigarettesPerDaySetting(settings, user),
                const SizedBox(height: 16),
                _buildPackPriceSetting(settings, user),
                const SizedBox(height: 16),
                _buildQuitDateSetting(settings, user),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCigarettesPerDaySetting(SettingsModel? settings, UserModel? user) {
    final currentValue = settings?.cigarettesPerDay ?? user?.cigarettesPerDay ?? 20;
    
    return ListTile(
      leading: const Icon(Icons.smoke_free),
      title: const Text('Сигарет в день'),
      subtitle: Text('$currentValue сигарет'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showCigarettesDialog(currentValue),
    );
  }

  Widget _buildPackPriceSetting(SettingsModel? settings, UserModel? user) {
    final currentValue = settings?.packPrice ?? user?.packPrice ?? 5.0;
    
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: const Text('Цена пачки'),
      subtitle: Text('${currentValue.toStringAsFixed(0)} ₽'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showPackPriceDialog(currentValue),
    );
  }

  Widget _buildQuitDateSetting(SettingsModel? settings, UserModel? user) {
    final quitDate = settings?.quitDate ?? user?.quitDate;
    final dateText = quitDate != null 
        ? '${quitDate.day}.${quitDate.month}.${quitDate.year}'
        : 'Не установлена';

    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('Дата отказа'),
      subtitle: Text(dateText),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showQuitDateDialog(),
    );
  }

  Widget _buildNotificationSettings() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final settings = settingsProvider.settings;
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Уведомления',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Включить уведомления'),
                  subtitle: const Text('Ежедневные напоминания'),
                  value: settings?.notificationsEnabled ?? true,
                  onChanged: (value) => _updateNotifications(value),
                ),
                if (settings?.notificationsEnabled ?? true) ...[
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Время уведомлений'),
                    subtitle: Text(settings?.notificationTime ?? '09:00'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showNotificationTimeDialog(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'О приложении',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Версия'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Политика конфиденциальности'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showPrivacyPolicy(),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Условия использования'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showTermsOfService(),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              onTap: () async {
                Navigator.of(context).pop();
                await context.setLocale(const Locale('ru'));
                final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                await settingsProvider.updateLanguage('ru');
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () async {
                Navigator.of(context).pop();
                await context.setLocale(const Locale('en'));
                final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                await settingsProvider.updateLanguage('en');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Системная'),
              onTap: () async {
                Navigator.of(context).pop();
                final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                await settingsProvider.updateTheme('system');
              },
            ),
            ListTile(
              title: const Text('Светлая'),
              onTap: () async {
                Navigator.of(context).pop();
                final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                await settingsProvider.updateTheme('light');
              },
            ),
            ListTile(
              title: const Text('Тёмная'),
              onTap: () async {
                Navigator.of(context).pop();
                final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                await settingsProvider.updateTheme('dark');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCigarettesDialog(int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сигарет в день'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Количество сигарет',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.of(context).pop();
                final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                
                await settingsProvider.updateSmokingSettings(cigarettesPerDay: value);
                await userProvider.updateSmokingSettings(cigarettesPerDay: value);
                
                setState(() {
                  _cigarettesController.text = value.toString();
                });
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showPackPriceDialog(double currentValue) {
    final controller = TextEditingController(text: currentValue.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Цена пачки'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Цена в рублях',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.of(context).pop();
                final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                
                await settingsProvider.updateSmokingSettings(packPrice: value);
                await userProvider.updateSmokingSettings(packPrice: value);
                
                setState(() {
                  _packPriceController.text = value.toString();
                });
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showQuitDateDialog() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (selectedDate != null) {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      await settingsProvider.setQuitDate(selectedDate);
      await userProvider.setQuitDate(selectedDate);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Дата отказа установлена'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _updateNotifications(bool enabled) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    await settingsProvider.updateNotificationSettings(enabled: enabled);
  }

  void _showNotificationTimeDialog() {
    // В реальном приложении здесь можно использовать TimePicker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Время уведомлений'),
        content: const Text('Функция в разработке'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Политика конфиденциальности'),
        content: const Text('Здесь будет текст политики конфиденциальности.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Условия использования'),
        content: const Text('Здесь будут условия использования приложения.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
} 