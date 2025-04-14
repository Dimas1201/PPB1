import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/main_screen.dart';
import 'models/todo.dart'; // tambahkan di paling atas juga

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter()); // Wajib!

  var settingsBox = await Hive.openBox('settings');
  String theme = settingsBox.get('theme', defaultValue: 'Light');

  runApp(MyApp(theme: theme));
}


class MyApp extends StatelessWidget {
  final String theme;

  const MyApp({required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: theme == 'Light' ? ThemeData.light() : ThemeData.dark(),
      home: MainScreen(theme: theme),
    );
  }
}
