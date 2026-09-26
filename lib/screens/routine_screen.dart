import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/class_card.dart';
import '../widgets/ui.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  int selectedDay = DateTime.now().weekday - 1;
  final List<_RoutineEntry> entries = [
    _RoutineEntry(time: '09:00 – 10:00', title: 'Mathematics', room: 'Room 204', subjectId: 'math', color: const Color(0xFF6876E8)),
    _RoutineEntry(time: '11:15 – 12:15', title: 'Physics', room: 'Lab 2', subjectId: 'physics', color: const Color(0xFF39BFA4)),
    _RoutineEntry(time: '14:00 – 15:00', title: 'English', room: 'Room 108', subjectId: 'english', color: const Color(0xFFF0A65B)),
  ];

  @override
  Widget build(BuildContext context) {
    final language = AppScope.of(context).language;
    final dayLabels = language == AppLanguage.bn
        ? const ['সো', 'ম', 'বু', 'বৃ', 'শু', 'শ', 'র']
        : language == AppLanguage.hi
            ? const ['सो', 'मं', 'बु', 'गु', 'शु', 'श', 'र']
            : const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Scaffold(
      backgroundColor: AppColors.canvas,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addClass,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(tr(language, 'add_class')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr(language, 'routine'), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 5),
          Text(tr(language, 'weekly_routine'), style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 22),
          WhitePanel(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(7, (index) {
              final active = selectedDay == index;
              return GestureDetector(
                onTap: () => setState(() => selectedDay = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 39,
                  height: 53,
                  decoration: BoxDecoration(color: active ? AppColors.brand : Colors.transparent, borderRadius: BorderRadius.circular(15)),
                  child: Center(child: Text(dayLabels[index], style: TextStyle(color: active ? Colors.white : AppColors.muted, fontWeight: FontWeight.w800))),
                ),
              );
            })),
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: Text(selectedDay == DateTime.now().weekday - 1 ? tr(language, 'today_label') : tr(language, 'this_week'), style: const TextStyle(color: AppColors.muted, letterSpacing: 1, fontSize: 11, fontWeight: FontWeight.w800))),
            Text('${entries.length} ${tr(language, 'classes')}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ]),
          const SizedBox(height: 13),
          if (entries.isEmpty)
            WhitePanel(child: Center(child: Text(tr(language, 'no_classes'), style: const TextStyle(color: AppColors.muted))))
          else
            ...entries.map((entry) => ClassCard(time: entry.time, title: entry.title, room: entry.room, subjectId: entry.subjectId, accent: entry.color, showAttendanceAction: false)),
          const SizedBox(height: 20),
          WhitePanel(
            child: Row(children: [
              const SoftIcon(Icons.tips_and_updates_outlined, background: AppColors.paleAmber, color: Color(0xFFD88B3F)),
              const SizedBox(width: 12),
              Expanded(child: Text(tr(language, 'routine_tip'), style: const TextStyle(fontSize: 12, height: 1.45, color: AppColors.muted))),
            ]),
          ),
        ]),
      ),
    );
  }

  Future<void> _addClass() async {
    final titleController = TextEditingController();
    final roomController = TextEditingController();
    final result = await showModalBottomSheet<_RoutineEntry>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.viewInsetsOf(sheetContext).bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr(AppScope.of(context).language, 'add_class'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(controller: titleController, decoration: InputDecoration(labelText: tr(AppScope.of(context).language, 'subject'))),
          const SizedBox(height: 10),
          TextField(controller: roomController, decoration: const InputDecoration(labelText: 'Room / location')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: () => Navigator.pop(sheetContext, _RoutineEntry(
              time: '09:00 – 10:00', title: titleController.text.trim().isEmpty ? 'New class' : titleController.text.trim(),
              room: roomController.text.trim().isEmpty ? 'Add location' : roomController.text.trim(),
              subjectId: 'math', color: AppColors.brand,
            )),
            child: Text(tr(AppScope.of(context).language, 'save')),
          )),
        ]),
      ),
    );
    titleController.dispose();
    roomController.dispose();
    if (result != null && mounted) setState(() => entries.add(result));
  }
}

class _RoutineEntry {
  const _RoutineEntry({required this.time, required this.title, required this.room, required this.subjectId, required this.color});
  final String time;
  final String title;
  final String room;
  final String subjectId;
  final Color color;
}
