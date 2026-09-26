import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/ui.dart';
import 'language_screen.dart';
import 'quick_setup_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(tr(language, 'settings'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          WhitePanel(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFFFE3D8),
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Color(0xFF9E533B),
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr(language, 'hello'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                      const SizedBox(height: 4),
                      Text(tr(language, 'profile'), style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeading(title: tr(language, 'preferences')),
          const SizedBox(height: 9),
          WhitePanel(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen())),
            child: Row(
              children: [
                const SoftIcon(Icons.translate_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr(language, 'language'), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(controller.language.nativeName, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ],
            ),
          ),
          const SizedBox(height: 11),
          WhitePanel(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SoftIcon(Icons.donut_large_rounded),
                    const SizedBox(width: 12),
                    Expanded(child: Text(tr(language, 'attendance_target'), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700))),
                    Text('${controller.attendanceTarget}%', style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 15),
                Slider(
                  value: controller.attendanceTarget.toDouble(),
                  min: 50,
                  max: 100,
                  divisions: 10,
                  label: '${controller.attendanceTarget}%',
                  onChanged: (value) => controller.setTarget(value.round()),
                ),
                Text(tr(language, 'target_note'), style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 11),
          WhitePanel(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuickSetupScreen())),
            child: Row(
              children: [
                const SoftIcon(Icons.menu_book_rounded, background: AppColors.paleMint, color: AppColors.mint),
                const SizedBox(width: 12),
                Expanded(child: Text(tr(language, 'edit_subjects'), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700))),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeading(title: tr(language, 'about')),
          const SizedBox(height: 9),
          WhitePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ClassBondhu: Student Planner', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 6),
                Text(tr(language, 'offline_privacy_note'), style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.45)),
                const SizedBox(height: 9),
                const Text('Version 0.1.0 · UI prototype', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
