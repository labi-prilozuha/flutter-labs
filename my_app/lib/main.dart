import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
      ),
      home: const HabitsHomeScreen(),
    );
  }
}

/// Главный экран со списком привычек и блоком мотивации.
class HabitsHomeScreen extends StatefulWidget {
  const HabitsHomeScreen({super.key});

  @override
  State<HabitsHomeScreen> createState() => _HabitsHomeScreenState();
}

class _HabitsHomeScreenState extends State<HabitsHomeScreen> {
  final List<HabitItem> _habits = [
    const HabitItem(
      title: 'Выпить стакан воды',
      subtitle: 'Ежедневно',
      isDone: true,
    ),
    const HabitItem(
      title: 'Почитать 10 минут',
      subtitle: 'Пн, Ср, Пт',
      isDone: false,
    ),
    const HabitItem(
      title: 'Прогулка 20 минут',
      subtitle: 'Ежедневно',
      isDone: true,
    ),
  ];

  final TextEditingController _newHabitController = TextEditingController();

  @override
  void dispose() {
    _newHabitController.dispose();
    super.dispose();
  }

  void _openAddHabitDialog() {
    _newHabitController.clear();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новая привычка'),
          content: TextField(
            controller: _newHabitController,
            decoration: const InputDecoration(
              hintText: 'Например: Сделать растяжку',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                final text = _newHabitController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _habits.add(
                      HabitItem(
                        title: text,
                        subtitle: 'Ежедневно',
                        isDone: false,
                      ),
                    );
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _openStats() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const HabitStatsScreen(),
      ),
    );
  }

  void _openEditHabit() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const EditHabitScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitFlow'),
        centerTitle: false,
      ),
      drawer: _MainDrawer(
        onOpenHome: () => Navigator.of(context).pop(),
        onOpenNewHabit: _openEditHabit,
        onOpenStats: _openStats,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MotivationCard(),
            const SizedBox(height: 24),
            Text(
              'Сегодня',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return HabitListItem(
                    title: habit.title,
                    subtitle: habit.subtitle,
                    isDone: habit.isDone,
                    onTap: _openStats,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton.icon(
        onPressed: _openAddHabitDialog,
        icon: const Icon(Icons.add),
        label: const Text('Добавить привычку'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Мотивация дня',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[900],
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            '«Сегодня отличный день, чтобы сделать шаг к своей цели!»',
          ),
          const SizedBox(height: 4),
          Text(
            '— HabitFlow',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }
}

class HabitListItem extends StatelessWidget {
  const HabitListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDone,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isDone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? colorScheme.primary : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDone ? Colors.black : Colors.black87,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.bar_chart_rounded),
        onTap: onTap,
      ),
    );
  }
}

/// Экран добавления / редактирования привычки.
class EditHabitScreen extends StatelessWidget {
  const EditHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Новая привычка'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Название'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Например: Выпить стакан воды',
                border: OutlineInputBorder(),
              ),
              enabled: false, // ЛР4: поле как часть вёрстки, без логики
            ),
            const SizedBox(height: 16),
            const Text('Описание'),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Необязательно: зачем нужна привычка',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            const Text('Иконка'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                _IconPreview('😀'),
                _IconPreview('💧'),
                _IconPreview('📚'),
                _IconPreview('🏃'),
                _IconPreview('🧘'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Частота'),
            const SizedBox(height: 8),
            const _FrequencySection(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: null, // ЛР4: без сохранения
                    child: const Text('Сохранить'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: null, // ЛР4: без логики
                    child: const Text('Отмена'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconPreview extends StatelessWidget {
  const _IconPreview(this.emoji);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

class _FrequencySection extends StatelessWidget {
  const _FrequencySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.radio_button_checked, size: 20),
            SizedBox(width: 8),
            Text('Ежедневно'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.radio_button_unchecked, size: 20),
            SizedBox(width: 8),
            Text('По дням недели'),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: const [
            _DayChip(label: 'Пн'),
            _DayChip(label: 'Вт'),
            _DayChip(label: 'Ср'),
            _DayChip(label: 'Чт'),
            _DayChip(label: 'Пт'),
            _DayChip(label: 'Сб'),
            _DayChip(label: 'Вс'),
          ],
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[200],
    );
  }
}

/// Экран статистики по привычке.
class HabitStatsScreen extends StatelessWidget {
  const HabitStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Статистика: "Почитать 10 минут"'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Текущая серия: 5 дней подряд',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Всего выполнено за 30 дней: 18'),
            const SizedBox(height: 24),
            Text(
              'История (последние 7 дней)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  _HistoryRow(day: 'Пн', done: true),
                  _HistoryRow(day: 'Вт', done: false),
                  _HistoryRow(day: 'Ср', done: true),
                  _HistoryRow(day: 'Чт', done: true),
                  _HistoryRow(day: 'Пт', done: true),
                  _HistoryRow(day: 'Сб', done: false),
                  _HistoryRow(day: 'Вс', done: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.day, required this.done});

  final String day;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Text(day),
      trailing: Icon(
        done ? Icons.check_circle : Icons.cancel_outlined,
        color: done ? colorScheme.primary : Colors.redAccent,
      ),
    );
  }
}

class HabitItem {
  const HabitItem({
    required this.title,
    required this.subtitle,
    required this.isDone,
  });

  final String title;
  final String subtitle;
  final bool isDone;
}

class _MainDrawer extends StatelessWidget {
  const _MainDrawer({
    required this.onOpenHome,
    required this.onOpenNewHabit,
    required this.onOpenStats,
  });

  final VoidCallback onOpenHome;
  final VoidCallback onOpenNewHabit;
  final VoidCallback onOpenStats;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'HabitFlow',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Мои привычки'),
              onTap: onOpenHome,
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Новая привычка'),
              onTap: onOpenNewHabit,
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Статистика (пример)'),
              onTap: onOpenStats,
            ),
          ],
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
