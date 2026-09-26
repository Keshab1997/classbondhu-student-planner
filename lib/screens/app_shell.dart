import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import 'attendance_screen.dart';
import 'routine_screen.dart';
import 'tasks_screen.dart';
import 'today_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final language = AppScope.of(context).language;
    final labels = [
      tr(language, 'today'),
      tr(language, 'routine'),
      tr(language, 'attendance'),
      tr(language, 'tasks'),
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: index,
          children: [
            TodayScreen(onViewRoutine: () => setState(() => index = 1)),
            const RoutineScreen(),
            const AttendanceScreen(),
            const TasksScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.wb_sunny_outlined), selectedIcon: const Icon(Icons.wb_sunny_rounded), label: labels[0]),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), selectedIcon: const Icon(Icons.calendar_month_rounded), label: labels[1]),
          NavigationDestination(icon: const Icon(Icons.donut_large_outlined), selectedIcon: const Icon(Icons.donut_large_rounded), label: labels[2]),
          NavigationDestination(icon: const Icon(Icons.checklist_rounded), selectedIcon: const Icon(Icons.checklist_rounded), label: labels[3]),
        ],
      ),
    );
  }
}
