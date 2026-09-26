import 'package:flutter/material.dart';

import 'core/app_controller.dart';
import 'core/app_theme.dart';
import 'screens/app_shell.dart';

class ClassBondhuApp extends StatefulWidget {
  const ClassBondhuApp({this.controller, super.key});

  final AppController? controller;

  @override
  State<ClassBondhuApp> createState() => _ClassBondhuAppState();
}

class _ClassBondhuAppState extends State<ClassBondhuApp> {
  late final AppController controller;
  late final bool ownsController;

  @override
  void initState() {
    super.initState();
    ownsController = widget.controller == null;
    controller = widget.controller ?? AppController();
  }

  @override
  void dispose() {
    if (ownsController) controller.dispose();
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
