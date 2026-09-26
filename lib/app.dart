import 'package:flutter/material.dart';

import 'core/app_controller.dart';
import 'core/app_theme.dart';
import 'screens/app_shell.dart';

class ClassBondhuApp extends StatefulWidget {
  const ClassBondhuApp({super.key});

  @override
  State<ClassBondhuApp> createState() => _ClassBondhuAppState();
}

class _ClassBondhuAppState extends State<ClassBondhuApp> {
  final AppController controller = AppController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScope(
        controller: controller,
        child: MaterialApp(
          title: 'ClassBondhu: Student Planner',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          home: const AppShell(),
        ),
      );
}
