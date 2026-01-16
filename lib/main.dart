import 'package:e_shop/constants/theme_data.dart';
import 'package:e_shop/firebase_options.dart';
import 'package:e_shop/provider/theme_provider.dart';
import 'package:e_shop/root_sreen.dart';
import 'package:e_shop/screens/admin/admin_screen.dart';
import 'package:e_shop/screens/auth/login_screen.dart';
import 'package:e_shop/screens/auth/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Shop App',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const LoginScreen(),
            routes: {
              LoginScreen.routName: (context) => const LoginScreen(),
              RegisterScreen.routName: (context) => const RegisterScreen(),
              RootScreen.routName: (context) => const RootScreen(),
              '/admin': (context) => const AdminScreen(),
            },
          );
        },
      ),
    ),
  );
}
