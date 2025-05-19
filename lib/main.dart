import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_screen.dart';
import 'screens/login.dart';  // Pastikan import LoginScreen
import 'screens/register.dart';  // Jika ada RegisterScreen
import 'screens/home.dart';  // Jika ada HomeScreen
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initializeNotification();

  // Menunggu Firebase inisiasi
  await Firebase.initializeApp();

  const String theme = 'Light'; // Atur tema default sesuai kebutuhan

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final String theme;

  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Story Base',
      theme: theme == 'Light' ? ThemeData.light() : ThemeData.dark(),
      initialRoute: 'login', // Set halaman awal ke login
      routes: {
        'login': (context) => const LoginScreen(),  // Rute untuk login
        'register': (context) => const RegisterScreen(),  // Rute untuk register
        'home': (context) => const HomeScreen(),  // Rute untuk halaman home
        'main': (context) => const MainScreen(theme: 'Light'),  // Rute untuk MainScreen
      },
    );
  }
}
