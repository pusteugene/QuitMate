import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/progress_provider.dart';
import '../providers/user_provider.dart';
import '../models/progress_model.dart';
import '../models/achievement_model.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Прогресс'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Календарь'),
            Tab(text: 'Достижения'),
            Tab(text: 'Графики'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CalendarTab(),
          AchievementsTab(),
          ChartsTab(),
        ],
      ),
    );
  }
}

class CalendarTab extends StatelessWidget {
  const CalendarTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        final progressList = progressProvider.progressList;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Календарь бросания',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildCalendar(progressList),
              const SizedBox(height: 24),
              _buildProgressList(progressList),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendar(List<ProgressModel> progressList) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCalendarGrid(currentMonth, progressList),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime month, List<ProgressModel> progressList) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDay.weekday;
    final daysInMonth = lastDay.day;
    
    final days = <Widget>[];
    
    // Добавляем пустые дни в начале
    for (int i = 1; i < firstWeekday; i++) {
      days.add(const SizedBox());
    }
    
    // Добавляем дни месяца
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final hasProgress = progressList.any((p) => 
          p.date.year == date.year && 
          p.date.month == date.month && 
          p.date.day == date.day);
      
      days.add(
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: hasProgress ? Colors.green : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: hasProgress ? Border.all(color: Colors.green, width: 2) : null,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontWeight: hasProgress ? FontWeight.bold : FontWeight.normal,
                color: hasProgress ? Colors.white : null,
              ),
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        const Text('Пн', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('Вт', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('Ср', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('Чт', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('Пт', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('Сб', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('Вс', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        ...days,
      ],
    );
  }

  Widget _buildProgressList(List<ProgressModel> progressList) {
    if (progressList.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('Нет данных о прогрессе'),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'История прогресса',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...progressList.take(10).map((progress) => _buildProgressItem(progress)),
      ],
    );
  }

  Widget _buildProgressItem(ProgressModel progress) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            '${progress.daysSmokeFree}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('День ${progress.daysSmokeFree}'),
        subtitle: Text(
          '${progress.cigarettesAvoided} сигарет не выкурено • ${progress.moneySaved.toStringAsFixed(0)} ₽ сэкономлено',
        ),
        trailing: Text(
          '${progress.date.day}.${progress.date.month}.${progress.date.year}',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[month - 1];
  }
}

class AchievementsTab extends StatelessWidget {
  const AchievementsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        final achievements = progressProvider.achievements;
        final stats = progressProvider.getStats();
        final currentDays = stats['totalDays'] as int;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Достижения',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildAchievementsGrid(achievements, currentDays),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAchievementsGrid(List<Achievement> achievements, int currentDays) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isUnlocked = currentDays >= achievement.daysRequired;
        
        return Card(
          elevation: isUnlocked ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isUnlocked 
                  ? LinearGradient(
                      colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isUnlocked ? Icons.emoji_events : Icons.lock,
                    size: 48,
                    color: isUnlocked ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    achievement.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.green : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${achievement.daysRequired} дней',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (isUnlocked && achievement.unlockedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Получено ${achievement.unlockedAt!.day}.${achievement.unlockedAt!.month}.${achievement.unlockedAt!.year}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChartsTab extends StatelessWidget {
  const ChartsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        final progressList = progressProvider.progressList;
        
        if (progressList.isEmpty) {
          return const Center(
            child: Text('Нет данных для отображения графиков'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Графики прогресса',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDaysChart(progressList),
              const SizedBox(height: 24),
              _buildCigarettesChart(progressList),
              const SizedBox(height: 24),
              _buildMoneyChart(progressList),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDaysChart(List<ProgressModel> progressList) {
    final chartData = progressList.take(30).map((p) => 
        FlSpot(p.daysSmokeFree.toDouble(), p.daysSmokeFree.toDouble())
    ).toList();

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
              'Дни без курения',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCigarettesChart(List<ProgressModel> progressList) {
    final chartData = progressList.take(30).map((p) => 
        FlSpot(p.daysSmokeFree.toDouble(), p.cigarettesAvoided.toDouble())
    ).toList();

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
              'Не выкуренные сигареты',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyChart(List<ProgressModel> progressList) {
    final chartData = progressList.take(30).map((p) => 
        FlSpot(p.daysSmokeFree.toDouble(), p.moneySaved)
    ).toList();

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
              'Сэкономленные деньги',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 