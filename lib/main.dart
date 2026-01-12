import 'package:e_shop/constants/theme_data.dart';
import 'package:e_shop/firebase_options.dart';
import 'package:e_shop/provider/theme_provider.dart';
import 'package:e_shop/root_sreen.dart'; // note: you have a typo in file name (root_sreen.dart)
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart'; // Add your NoteProvider here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()), // <-- added NoteProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Shop App',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTHeme,
              context: context,
            ),
            home: const RootScreen(), // RootScreen handles all your pages
          );
        },
      ),
    ),
  );
}
