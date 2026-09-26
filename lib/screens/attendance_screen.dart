import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/attendance_math.dart';
import '../core/app_theme.dart';
import '../widgets/ui.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    final total = controller.subjects.fold<int>(0, (sum, subject) => sum + subject.conducted);
    final attended = controller.subjects.fold<int>(0, (sum, subject) => sum + subject.attended);
    final overall = total == 0 ? 0.0 : attended / total;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSubject(context),
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(tr(language, 'add_subject')),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 96), children: [
        Text(tr(language, 'attendance'), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        Text(tr(language, 'attendance_summary'), style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF596BE0), Color(0xFF7885EE)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Color(0x255967D9), blurRadius: 24, offset: Offset(0, 10))],
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr(language, 'overall_attendance').toUpperCase(), style: const TextStyle(color: Color(0xFFDDE1FF), fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
              const SizedBox(height: 7),
              Text('${(overall * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -1.2)),
              const SizedBox(height: 5),
              Text('$attended ${tr(language, 'of')} $total ${tr(language, 'classes_attended')}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ])),
            SizedBox(width: 73, height: 73, child: Stack(alignment: Alignment.center, children: [
              SizedBox.expand(child: CircularProgressIndicator(value: overall, strokeWidth: 7, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white))),
              const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 27),
            ])),
          ]),
        ),
        const SizedBox(height: 26),
        SectionHeading(title: tr(language, 'all_subjects'), action: '${controller.subjects.length}'),
        const SizedBox(height: 10),
        ...controller.subjects.map((subject) {
          final percent = subject.percentage;
          final atTarget = percent * 100 >= controller.attendanceTarget;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WhitePanel(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SubjectDetailScreen(subjectId: subject.id))),
              padding: const EdgeInsets.all(17),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 42, height: 42, decoration: BoxDecoration(color: Color(subject.color).withValues(alpha: .12), borderRadius: BorderRadius.circular(14)), child: Icon(Icons.menu_book_rounded, color: Color(subject.color), size: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink, fontSize: 15)),
                        const SizedBox(height: 3),
                        Text('${subject.attended}/${subject.conducted} ${tr(language, 'classes_attended')}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('${(percent * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.ink)),
                ]),
                const SizedBox(height: 15),
                ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: percent, minHeight: 7, backgroundColor: AppColors.line, valueColor: AlwaysStoppedAnimation(Color(subject.color)))),
                const SizedBox(height: 11),
                Row(children: [
                  StatusPill(
                    text: subject.conducted == 0
                        ? tr(language, 'no_attendance_yet')
                        : atTarget
                            ? tr(language, 'on_track_status')
                            : tr(language, 'needs_attention'),
                    good: subject.conducted == 0 || atTarget,
                  ),
                  const Spacer(),
                  Text('${tr(language, 'target')} ${controller.attendanceTarget}%', style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 3),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 18),
                ]),
              ]),
            ),
          );
        }),
        const SizedBox(height: 2),
        Text(tr(language, 'attendance_disclaimer'), style: const TextStyle(fontSize: 11, color: AppColors.muted, height: 1.45)),
      ]),
    );
  }

  void _addSubject(BuildContext context) {
    final controller = TextEditingController();
    final language = AppScope.of(context).language;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr(language, 'add_subject')),
        content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(hintText: tr(language, 'subject_name'))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(tr(language, 'cancel'))),
          FilledButton(onPressed: () { AppScope.of(context).addSubject(controller.text); Navigator.pop(dialogContext); }, child: Text(tr(language, 'save'))),
        ],
      ),
    ).whenComplete(controller.dispose);
  }
}

class SubjectDetailScreen extends StatelessWidget {
  const SubjectDetailScreen({required this.subjectId, super.key});
  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    final subject = controller.subjects.firstWhere((item) => item.id == subjectId);
    final ratio = AttendanceMath.percentage(attended: subject.attended, conducted: subject.conducted);
    final needed = AttendanceMath.classesRequired(attended: subject.attended, conducted: subject.conducted, targetPercent: controller.attendanceTarget);
    final safeMisses = AttendanceMath.safeAbsences(attended: subject.attended, conducted: subject.conducted, targetPercent: controller.attendanceTarget);
    final atTarget = subject.conducted > 0 && ratio * 100 >= controller.attendanceTarget;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(subject.name)),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
        WhitePanel(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr(language, 'current_attendance'), style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 7),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${(ratio * 100).round()}%', style: const TextStyle(color: AppColors.ink, fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1.2)),
              const SizedBox(width: 10),
              Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('${subject.attended} ${tr(language, 'of')} ${subject.conducted} ${tr(language, 'classes_attended')}', style: const TextStyle(color: AppColors.muted, fontSize: 12))),
            ]),
            const SizedBox(height: 12),
            ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: ratio, minHeight: 9, backgroundColor: AppColors.line, valueColor: const AlwaysStoppedAnimation(AppColors.brand))),
            const SizedBox(height: 12),
            Text('${tr(language, 'target')} ${controller.attendanceTarget}%', style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 15),
        WhitePanel(
          child: Row(children: [
            const SoftIcon(Icons.lightbulb_outline_rounded, color: Color(0xFFD88B3F), background: AppColors.paleAmber),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(atTarget ? tr(language, 'safe_misses') : tr(language, 'classes_to_target'), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                subject.conducted == 0
                    ? tr(language, 'no_attendance_yet')
                    : atTarget
                        ? '$safeMisses ${tr(language, 'classes')}'
                        : needed == null
                            ? tr(language, 'attend_every_class')
                            : '$needed ${tr(language, 'classes_in_a_row')}',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ])),
          ]),
        ),
        const SizedBox(height: 25),
        SectionHeading(title: tr(language, 'recent_sessions')),
        const SizedBox(height: 10),
        WhitePanel(child: Column(children: [
          const Icon(Icons.history_rounded, size: 25, color: AppColors.muted),
          const SizedBox(height: 8),
          Text(tr(language, 'session_history_empty'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5)),
        ])),
      ]),
    );
  }
}
