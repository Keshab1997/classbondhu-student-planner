import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/class_card.dart';
import '../widgets/ui.dart';
import 'settings_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({this.onViewRoutine, super.key});
  final VoidCallback? onViewRoutine;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    final totalConducted = controller.subjects.fold<int>(0, (sum, item) => sum + item.conducted);
    final totalAttended = controller.subjects.fold<int>(0, (sum, item) => sum + item.attended);
    final ratio = totalConducted == 0 ? 0.0 : totalAttended / totalConducted;
    final percentage = (ratio * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(13)),
            child: const Icon(Icons.auto_stories_rounded, color: AppColors.brand, size: 22),
          ),
          const SizedBox(width: 10),
          const Text('ClassBondhu', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink, letterSpacing: -.4)),
          const Spacer(),
          IconButton(
            tooltip: tr(language, 'settings'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            icon: const Icon(Icons.tune_rounded, color: AppColors.ink),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
          const SizedBox(width: 6),
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFFFFE3D8), child: Text('A', style: TextStyle(color: Color(0xFF9E533B), fontWeight: FontWeight.w800))),
        ]),
        const SizedBox(height: 24),
        Text(AppDate.today(language), style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
        const SizedBox(height: 7),
        Text('${tr(language, 'good_morning')}, Ananya', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(tr(language, 'focused_day'), style: const TextStyle(color: AppColors.muted, fontSize: 14)),
        const SizedBox(height: 22),
        _AttendanceHero(percentage: percentage, target: controller.attendanceTarget, language: language),
        const SizedBox(height: 25),
        SectionHeading(title: tr(language, 'today_classes'), action: tr(language, 'see_all'), onAction: onViewRoutine),
        const SizedBox(height: 8),
        ClassCard(time: '09:00 – 10:00', title: 'Mathematics', room: 'Room 204', subjectId: 'math', accent: const Color(0xFF6876E8), isDone: true),
        ClassCard(time: '11:15 – 12:15', title: 'Physics', room: 'Lab 2', subjectId: 'physics', accent: const Color(0xFF39BFA4)),
        const SizedBox(height: 7),
        SectionHeading(title: tr(language, 'up_next')),
        const SizedBox(height: 8),
        WhitePanel(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const SoftIcon(Icons.assignment_outlined, color: Color(0xFFD88B3F), background: AppColors.paleAmber),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr(language, 'due_tomorrow').toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: .9, color: Color(0xFFD88B3F), fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Physics assignment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 3),
              const Text('Tomorrow · 10:00 AM', style: TextStyle(fontSize: 12, color: AppColors.muted)),
            ])),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ]),
        ),
      ]),
    );
  }
}

class _AttendanceHero extends StatelessWidget {
  const _AttendanceHero({required this.percentage, required this.target, required this.language});
  final int percentage;
  final int target;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.line),
          boxShadow: const [BoxShadow(color: Color(0x0B12224A), blurRadius: 24, offset: Offset(0, 9))],
        ),
        child: Row(children: [
          SizedBox(
            width: 94,
            height: 94,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox.expand(child: CircularProgressIndicator(value: percentage / 100, strokeWidth: 8, strokeCap: StrokeCap.round, backgroundColor: AppColors.paleBlue, valueColor: const AlwaysStoppedAnimation(AppColors.brand))),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text('$percentage%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink, letterSpacing: -1)),
                const Text('OVERALL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: .8, color: AppColors.muted)),
              ]),
            ]),
          ),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr(language, 'your_attendance'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink, fontSize: 15)),
            const SizedBox(height: 10),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(30)), child: Text('${tr(language, 'target')} $target%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.brand))),
            ]),
            const SizedBox(height: 9),
            Row(children: [const Icon(Icons.check_circle_rounded, color: AppColors.mint, size: 15), const SizedBox(width: 5), Flexible(child: Text(tr(language, 'on_track'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.mint))) ]),
          ])),
        ]),
      );
}
