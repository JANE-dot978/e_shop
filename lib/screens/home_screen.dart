import 'package:e_shop/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.network(
              'https://res.cloudinary.com/dgppqmq3t/image/upload/vanila_yhrijt',
              height: 250,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return const Text('Image failed to load');
              },
            ),
            Text(
              "My Shop",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: () {}, child: Text("Buy Now")),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("Admin Panel"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),

            SwitchListTile(
              title: Text(
                themeProvider.getIsDarkTheme ? "DARK THEME" : "LIGHT THEME",
              ),

              value: themeProvider.getIsDarkTheme,
              onChanged: (value) {
                themeProvider.setDarkTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}