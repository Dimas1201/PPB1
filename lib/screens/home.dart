import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';  // LoginScreen
import '../services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout(context) async {
    await FirebaseAuth.instance.signOut();

    await NotificationService.createNotification(
      id: 2,
      title: 'Logout Success',
      body: 'You are Sucessed to Logout!',
    );

    Navigator.pushReplacementNamed(context, 'login');
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jika pengguna sudah login (snapshot memiliki data)
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Account Information'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    // Tampilkan profile atau halaman lain jika diperlukan
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Logged in as ${snapshot.data?.email}'),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => logout(context),
                    child: const Text('Logout'),
                  )
                ],
              ),
            ),
          );
        } else {
          // Jika belum login, arahkan ke halaman login
          return const LoginScreen();
        }
      },
    );
  }
}
