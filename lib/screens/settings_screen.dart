import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  final String theme;
  final Function(String) onChangeTheme;

  SettingsScreen({required this.theme, required this.onChangeTheme});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.theme;
  }

  // Fungsi untuk menyimpan tema yang dipilih ke Hive
  Future<void> saveTheme(String theme) async {
    var box = await Hive.openBox('settings'); // Buka box 'settings'
    await box.put('theme', theme); // Menyimpan tema
  }

  // Fungsi untuk membaca tema yang disimpan di Hive
  Future<String> loadTheme() async {
    var box = await Hive.openBox('settings');
    return box.get('theme', defaultValue: 'Light'); // Jika tidak ada, gunakan default 'Light'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Theme:'),
            Container(
              height: 50,
              child: DropdownButton<String>(
                value: _selectedTheme,
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    // Simpan tema baru menggunakan Hive
                    await saveTheme(newValue);

                    setState(() {
                      _selectedTheme = newValue;
                    });
                    widget.onChangeTheme(newValue); // Notify parent widget
                  }
                },
                items: <String>[
                  'Light',
                  'Dark',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
