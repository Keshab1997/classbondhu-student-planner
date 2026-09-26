import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import 'ui.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({
    required this.time,
    required this.title,
    required this.room,
    required this.subjectId,
    required this.accent,
    this.isDone = false,
    this.showAttendanceAction = true,
    super.key,
  });

  final String time;
  final String title;
  final String room;
  final String subjectId;
  final Color accent;
  final bool isDone;
  final bool showAttendanceAction;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final bool? recordedToday = controller.todayAttendance[subjectId];
    final marked = isDone || recordedToday != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          width: 58,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(time.split(' – ').first, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 7),
            Container(width: 1.5, height: 43, color: AppColors.line),
          ]),
        ),
        Expanded(
          child: WhitePanel(
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Container(width: 4, height: 54, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10))),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.ink)),
                const SizedBox(height: 5),
                Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: AppColors.muted), const SizedBox(width: 3), Text(room, style: const TextStyle(fontSize: 12, color: AppColors.muted))]),
              ])),
              if (!showAttendanceAction)
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted)
              else if (marked)
                Icon(recordedToday == false ? Icons.cancel_rounded : Icons.check_circle_rounded, color: recordedToday == false ? const Color(0xFFE07A73) : AppColors.mint, size: 22)
              else
                IconButton(
                  tooltip: tr(controller.language, 'mark_attendance'),
                  onPressed: () => _showAttendanceActions(context, controller),
                  icon: const Icon(Icons.more_horiz_rounded, color: AppColors.brand),
                  style: IconButton.styleFrom(backgroundColor: AppColors.paleBlue),
                ),
            ]),
          ),
        ),
      ]),
    );
  }

  void _showAttendanceActions(BuildContext context, AppController controller) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(tr(controller.language, 'mark_attendance'), style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: FilledButton.icon(
                onPressed: () { controller.markAttendance(subjectId, present: true); Navigator.pop(sheetContext); },
                icon: const Icon(Icons.check_rounded), label: Text(tr(controller.language, 'present')),
                style: FilledButton.styleFrom(backgroundColor: AppColors.mint, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
              )),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(
                onPressed: () { controller.markAttendance(subjectId, present: false); Navigator.pop(sheetContext); },
                icon: const Icon(Icons.close_rounded), label: Text(tr(controller.language, 'absent')),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              )),
            ]),
          ]),
        ),
      ),
    );
  }
}
