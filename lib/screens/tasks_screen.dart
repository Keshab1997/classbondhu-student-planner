import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/ui.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    final tasks = controller.tasks.where((task) => task.done == showCompleted).toList();
    return Scaffold(
      backgroundColor: AppColors.canvas,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskEditorScreen())),
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(tr(language, 'add_task')),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 96), children: [
        Text(tr(language, 'tasks'), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        Text(tr(language, 'tasks_subtitle'), style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 20),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(tr(language, 'upcoming'))),
            ButtonSegment(value: true, label: Text(tr(language, 'completed'))),
          ],
          selected: {showCompleted},
          onSelectionChanged: (selection) => setState(() => showCompleted = selection.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 18),
        if (tasks.isEmpty)
          WhitePanel(child: Column(children: [const Icon(Icons.task_alt_rounded, size: 34, color: AppColors.brand), const SizedBox(height: 10), Text(tr(language, 'no_tasks'), style: const TextStyle(color: AppColors.muted))]))
        else
          ...tasks.map((task) {
            final icon = task.type == 'Quiz' ? Icons.quiz_outlined : task.type == 'Exam' ? Icons.school_outlined : Icons.assignment_outlined;
            final tint = task.type == 'Quiz' ? AppColors.paleBlue : AppColors.paleAmber;
            final iconColor = task.type == 'Quiz' ? AppColors.brand : const Color(0xFFD88B3F);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WhitePanel(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  InkWell(
                    onTap: () => controller.toggleTask(task.id),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(width: 27, height: 27, decoration: BoxDecoration(color: task.done ? AppColors.mint : Colors.white, border: Border.all(color: task.done ? AppColors.mint : AppColors.line, width: 1.5), borderRadius: BorderRadius.circular(9)), child: task.done ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null),
                  ),
                  const SizedBox(width: 12),
                  SoftIcon(icon, color: iconColor, background: tint, size: 42),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(task.title, style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, decoration: task.done ? TextDecoration.lineThrough : null)),
                    const SizedBox(height: 4),
                    Text('${task.subject} · ${task.dueLabel}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                  ])),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 19),
                ]),
              ),
            );
          }),
      ]),
    );
  }
}

class TaskEditorScreen extends StatefulWidget {
  const TaskEditorScreen({super.key});

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  String type = 'Assignment';
  String? subject;
  DateTime? dueDate;
  bool reminder = true;

  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(tr(language, 'add_task'))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 28), children: [
        TextField(controller: titleController, onChanged: (_) => setState(() {}), textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(labelText: tr(language, 'title'), hintText: tr(language, 'task_title_hint'))),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: type,
          decoration: InputDecoration(labelText: tr(language, 'task_type')),
          items: ['Assignment', 'Quiz', 'Exam', 'Other'].map((item) => DropdownMenuItem(value: item, child: Text(_localizedType(language, item)))).toList(),
          onChanged: (value) => setState(() => type = value ?? type),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: subject,
          decoration: InputDecoration(labelText: tr(language, 'subject')),
          items: [DropdownMenuItem<String>(value: null, child: Text(tr(language, 'no_subject'))), ...controller.subjects.map((item) => DropdownMenuItem(value: item.name, child: Text(item.name)))],
          onChanged: (value) => setState(() => subject = value),
        ),
        const SizedBox(height: 14),
        TextField(controller: detailsController, maxLines: 3, textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(labelText: tr(language, 'details_optional'), alignLabelWithHint: true)),
        const SizedBox(height: 14),
        WhitePanel(
          onTap: _pickDate,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(children: [const Icon(Icons.calendar_today_outlined, color: AppColors.brand, size: 20), const SizedBox(width: 12), Expanded(child: Text(dueDate == null ? tr(language, 'due_date') : _formatDate(dueDate!), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600))), const Icon(Icons.chevron_right_rounded, color: AppColors.muted)]),
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          value: reminder,
          onChanged: (value) => setState(() => reminder = value),
          contentPadding: const EdgeInsets.symmetric(horizontal: 3),
          title: Text(tr(language, 'reminder'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text(tr(language, 'reminder_hint'), style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: titleController.text.trim().isEmpty ? null : _save,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: AppColors.brand, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: Text(tr(language, 'save')),
        ),
      ]),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: dueDate ?? now.add(const Duration(days: 1)), firstDate: now, lastDate: now.add(const Duration(days: 365 * 3)));
    if (picked != null && mounted) setState(() => dueDate = picked);
  }

  void _save() {
    final dueLabel = dueDate == null ? tr(AppScope.of(context).language, 'no_due_date') : _formatDate(dueDate!);
    AppScope.of(context).addTask(title: titleController.text.trim(), subject: subject ?? tr(AppScope.of(context).language, 'no_subject'), dueLabel: dueLabel, type: type);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String _localizedType(AppLanguage language, String value) => switch (value) {
        'Assignment' => tr(language, 'assignment'),
        'Quiz' => tr(language, 'quiz'),
        'Exam' => tr(language, 'exam'),
        _ => tr(language, 'other'),
      };
}
