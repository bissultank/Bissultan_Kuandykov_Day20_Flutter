import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spa_project/core/theme/app_theme.dart';
import 'package:spa_project/features/home/presentation/controller/home_controller.dart';
import 'package:spa_project/features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: MaterialApp(
        title: 'ImageFinderApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}
