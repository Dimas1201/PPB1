import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/main_screen.dart';
import 'models/book.dart'; // pastikan ini file model barumu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Daftarkan adapter Book (bukan Todo lagi)
  Hive.registerAdapter(BookAdapter());

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
      title: 'Story Base', // Ganti dari 'To Do List'
      theme: theme == 'Light' ? ThemeData.light() : ThemeData.dark(),
      home: MainScreen(theme: theme),
    );
  }
}
