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

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    final dayLabels = language == AppLanguage.bn
        ? const ['সো', 'ম', 'বু', 'বৃ', 'শু', 'শ', 'র']
        : language == AppLanguage.hi
            ? const ['सो', 'मं', 'बु', 'गु', 'शु', 'श', 'र']
            : const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final entries = controller.routineEntries.where((entry) => entry.weekday == selectedDay + 1).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

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
            ...entries.map((entry) => ClassCard(
                  time: entry.time,
                  title: entry.title,
                  room: entry.room,
                  subjectId: entry.subjectId,
                  attendanceKey: entry.id,
                  accent: Color(entry.color),
                  showAttendanceAction: false,
                )),
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
    final controller = AppScope.of(context);
    final result = await showModalBottomSheet<RoutineEntryData>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.viewInsetsOf(sheetContext).bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr(controller.language, 'add_class'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(controller: titleController, decoration: InputDecoration(labelText: tr(controller.language, 'subject'))),
          const SizedBox(height: 10),
          TextField(controller: roomController, decoration: const InputDecoration(labelText: 'Room / location')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: () {
              final title = titleController.text.trim().isEmpty ? 'New class' : titleController.text.trim();
              var matchingSubjects = controller.subjects.where((item) => item.name.toLowerCase() == title.toLowerCase());
              if (matchingSubjects.isEmpty) {
                controller.addSubject(title);
                matchingSubjects = controller.subjects.where((item) => item.name.toLowerCase() == title.toLowerCase());
              }
              final subjectId = matchingSubjects.first.id;
              Navigator.pop(sheetContext, RoutineEntryData(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                weekday: selectedDay + 1,
                startTime: '09:00',
                endTime: '10:00',
                title: title,
                room: roomController.text.trim().isEmpty ? 'Add location' : roomController.text.trim(),
                subjectId: subjectId,
                color: 0xFF5868DB,
              ));
            },
            child: Text(tr(controller.language, 'save')),
          )),
        ]),
      ),
    );
    titleController.dispose();
    roomController.dispose();
    if (result != null && mounted) controller.addRoutineEntry(result);
  }
}
