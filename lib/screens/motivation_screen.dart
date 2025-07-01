import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({Key? key}) : super(key: key);

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final _reasonController = TextEditingController();

  final List<Map<String, String>> _dailyQuotes = [
    {
      'quote': 'Каждый день без курения - это победа над собой',
      'author': 'Неизвестный автор'
    },
    {
      'quote': 'Ваше здоровье - это ваш выбор',
      'author': 'Неизвестный автор'
    },
    {
      'quote': 'Сила воли сильнее любой зависимости',
      'author': 'Неизвестный автор'
    },
    {
      'quote': 'Сегодня ты делаешь выбор, который изменит завтра',
      'author': 'Неизвестный автор'
    },
    {
      'quote': 'Дыши свободно, живи полной жизнью',
      'author': 'Неизвестный автор'
    },
    {
      'quote': 'Ты сильнее, чем думаешь',
      'author': 'Неизвестный автор'
    },
    {
      'quote': 'Каждый вдох свежего воздуха - это подарок',
      'author': 'Неизвестный автор'
    },
    {
      'quote': 'Твоя семья заслуживает здорового тебя',
      'author': 'Неизвестный автор'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDailyQuote();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _loadDailyQuote() {
    // В реальном приложении здесь можно загружать цитату из API
    // или использовать дату для выбора цитаты
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мотивация'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDailyQuote(),
            const SizedBox(height: 24),
            _buildReasonsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyQuote() {
    final today = DateTime.now();
    final quoteIndex = today.day % _dailyQuotes.length;
    final quote = _dailyQuotes[quoteIndex];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.withOpacity(0.1), Colors.purple.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.format_quote,
                size: 48,
                color: Colors.blue[600],
              ),
              const SizedBox(height: 16),
              Text(
                '"${quote['quote']}"',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '- ${quote['author']}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Цитата дня',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonsSection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;
        final reasons = user?.reasons ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Мои причины',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _showAddReasonDialog,
                  icon: const Icon(Icons.add_circle),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (reasons.isEmpty)
              _buildEmptyReasons()
            else
              _buildReasonsList(reasons),
          ],
        );
      },
    );
  }

  Widget _buildEmptyReasons() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'У вас пока нет причин',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте свои причины отказа от курения для мотивации',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showAddReasonDialog,
              icon: const Icon(Icons.add),
              label: const Text('Добавить причину'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonsList(List<String> reasons) {
    return Column(
      children: reasons.asMap().entries.map((entry) {
        final index = entry.key;
        final reason = entry.value;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              reason,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              onPressed: () => _showDeleteReasonDialog(reason),
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showAddReasonDialog() {
    _reasonController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить причину'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Почему вы бросаете курить?'),
            const SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Ваша причина',
                border: OutlineInputBorder(),
                hintText: 'Например: для здоровья семьи',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final reason = _reasonController.text.trim();
              if (reason.isNotEmpty) {
                Navigator.of(context).pop();
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                await userProvider.addReason(reason);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Причина добавлена'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showDeleteReasonDialog(String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить причину'),
        content: Text('Вы уверены, что хотите удалить причину:\n"$reason"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              await userProvider.removeReason(reason);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Причина удалена'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
} 