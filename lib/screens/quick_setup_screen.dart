import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/ui.dart';

class QuickSetupScreen extends StatefulWidget {
  const QuickSetupScreen({super.key});

  @override
  State<QuickSetupScreen> createState() => _QuickSetupScreenState();
}

class _QuickSetupScreenState extends State<QuickSetupScreen> {
  final subjectController = TextEditingController();

  @override
  void dispose() {
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(tr(language, 'edit_subjects'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(tr(language, 'setup_title'), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(tr(language, 'setup_subtitle'), style: const TextStyle(color: AppColors.muted, height: 1.45)),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(child: TextField(controller: subjectController, textCapitalization: TextCapitalization.words, decoration: InputDecoration(hintText: tr(language, 'subject_name')))),
              const SizedBox(width: 9),
              IconButton.filled(
                onPressed: _addSubject,
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: Colors.white, minimumSize: const Size(52, 52)),
              ),
            ],
          ),
          const SizedBox(height: 19),
          SectionHeading(title: tr(language, 'subjects'), action: '${controller.subjects.length}'),
          const SizedBox(height: 8),
          ...controller.subjects.map((subject) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: WhitePanel(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: Row(
                    children: [
                      Container(width: 9, height: 32, decoration: BoxDecoration(color: Color(subject.color), borderRadius: BorderRadius.circular(9))),
                      const SizedBox(width: 12),
                      Expanded(child: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink))),
                      Text('${subject.attended}/${subject.conducted}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 10),
          WhitePanel(
            child: Row(
              children: [
                const SoftIcon(Icons.tips_and_updates_outlined, color: AppColors.brand),
                const SizedBox(width: 12),
                Expanded(child: Text(tr(language, 'setup_tip'), style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: AppColors.brand, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Text(tr(language, 'done')),
          ),
        ],
      ),
    );
  }

  void _addSubject() {
    AppScope.of(context).addSubject(subjectController.text);
    subjectController.clear();
    FocusScope.of(context).unfocus();
  }
}
