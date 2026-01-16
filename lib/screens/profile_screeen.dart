import 'package:e_shop/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(
                themeProvider.getIsDarkTheme
                    ? "Dark Theme"
                    : "Light Theme",
              ),
              value: themeProvider.getIsDarkTheme,
              onChanged: (value) {
                themeProvider.setDarkTheme(value);
                debugPrint(
                  'Theme State: ${themeProvider.getIsDarkTheme}',
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'This is the Profile Screen',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}