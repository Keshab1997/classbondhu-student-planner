import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(tr(language, 'settings'))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
        WhitePanel(
          child: Row(children: [
            const CircleAvatar(radius: 25, backgroundColor: Color(0xFFFFE3D8), child: Text('A', style: TextStyle(color: Color(0xFF9E533B), fontWeight: FontWeight.w800, fontSize: 18))),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(tr(language, 'hello'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)), const SizedBox(height: 4), Text(tr(language, 'profile'), style: const TextStyle(fontSize: 12, color: AppColors.muted))])),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ]),
        ),
        const SizedBox(height: 22),
        SectionHeading(title: tr(language, 'preferences')),
        const SizedBox(height: 9),
        WhitePanel(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen())),
          child: Row(children: [const SoftIcon(Icons.translate_rounded), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(tr(language, 'language'), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(controller.language.nativeName, style: const TextStyle(color: AppColors.muted, fontSize: 12))])), const Icon(Icons.chevron_right_rounded, color: AppColors.muted)]),
        ),
        const SizedBox(height: 11),
        WhitePanel(
          padding: const EdgeInsets.all(17),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const SoftIcon(Icons.donut_large_rounded), const SizedBox(width: 12), Expanded(child: Text(tr(language, 'attendance_target'), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700))), Text('${controller.attendanceTarget}%', style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w800))]),
            const SizedBox(height: 15),
            Slider(value: controller.attendanceTarget.toDouble(), min: 50, max: 100, divisions: 10, label: '${controller.attendanceTarget}%', onChanged: (value) => controller.setTarget(value.round())),
            Text(tr(language, 'target_note'), style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.4)),
          ]),
        ),
        const SizedBox(height: 11),
        WhitePanel(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuickSetupScreen())),
          child: Row(children: [const SoftIcon(Icons.menu_book_rounded, background: AppColors.paleMint, color: AppColors.mint), const SizedBox(width: 12), Expanded(child: Text(tr(language, 'edit_subjects'), style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700))), const Icon(Icons.chevron_right_rounded, color: AppColors.muted)]),
        ),
        const SizedBox(height: 22),
        SectionHeading(title: tr(language, 'about')),
        const SizedBox(height: 9),
        WhitePanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ClassBondhu: Student Planner', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
          const SizedBox(height: 6),
          Text(tr(language, 'offline_privacy_note'), style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.45)),
          const SizedBox(height: 9),
          const Text('Version 0.1.0 · UI prototype', style: TextStyle(color: AppColors.muted, fontSize: 11)),
        ])),
      ]),
    );
  }
}
EOF
cat > lib/screens/language_screen.dart <<'EOF'
import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';
import '../widgets/ui.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final language = controller.language;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(title: Text(tr(language, 'language'))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
        Text(tr(language, 'choose_language'), style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 17),
        ...AppLanguage.values.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: WhitePanel(
            onTap: () { controller.setLanguage(option); Navigator.pop(context); },
            child: Row(children: [
              Container(width: 46, height: 46, decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(15)), child: Center(child: Text(option == AppLanguage.bn ? 'অ' : option == AppLanguage.hi ? 'अ' : 'A', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.brand)))),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(option.nativeName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)), const SizedBox(height: 3), Text(option.label, style: const TextStyle(color: AppColors.muted, fontSize: 12))])),
              if (language == option) const Icon(Icons.check_circle_rounded, color: AppColors.brand),
            ]),
          ),
        )),
        const SizedBox(height: 6),
        Text(tr(language, 'language_data_note'), style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5)),
      ]),
    );
  }
}
EOF
cat > lib/screens/quick_setup_screen.dart <<'EOF'
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
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
        Text(tr(language, 'setup_title'), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(tr(language, 'setup_subtitle'), style: const TextStyle(color: AppColors.muted, height: 1.45)),
        const SizedBox(height: 19),
        Row(children: [
          Expanded(child: TextField(controller: subjectController, textCapitalization: TextCapitalization.words, decoration: InputDecoration(hintText: tr(language, 'subject_name')))),
          const SizedBox(width: 9),
          IconButton.filled(onPressed: _addSubject, icon: const Icon(Icons.add_rounded), style: IconButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: Colors.white, minimumSize: const Size(52, 52))),
        ]),
        const SizedBox(height: 19),
        SectionHeading(title: tr(language, 'subjects'), action: '${controller.subjects.length}'),
        const SizedBox(height: 8),
        ...controller.subjects.map((subject) => Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: WhitePanel(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13), child: Row(children: [Container(width: 9, height: 32, decoration: BoxDecoration(color: Color(subject.color), borderRadius: BorderRadius.circular(9))), const SizedBox(width: 12), Expanded(child: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink))), Text('${subject.attended}/${subject.conducted}', style: const TextStyle(color: AppColors.muted, fontSize: 12))])),
        )),
        const SizedBox(height: 10),
        WhitePanel(
          child: Row(children: [const SoftIcon(Icons.tips_and_updates_outlined, color: AppColors.brand), const SizedBox(width: 12), Expanded(child: Text(tr(language, 'setup_tip'), style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5)))]),
        ),
        const SizedBox(height: 20),
        FilledButton(onPressed: () => Navigator.pop(context), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: AppColors.brand, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(tr(language, 'done'))),
      ]),
    );
  }

  void _addSubject() {
    AppScope.of(context).addSubject(subjectController.text);
    subjectController.clear();
    FocusScope.of(context).unfocus();
  }
}
EOF
cat > design/README.md <<'EOF'
# ClassBondhu UI reference

The selected visual direction is the **first light-theme home concept** (`home-reference.png`): warm off-white canvas, midnight-navy type, indigo-blue primary actions, mint attendance-positive state, soft rounded cards, and generous spacing.

The later dark/glassmorphism explorations are not the selected direction. Flutter widgets in `lib/` are being built from the selected light reference, with legible contrast and adaptation for Bengali, English, and Hindi.

`home-reference.png` is an AI-generated visual inspiration, not a production screenshot. It is included so contributors can compare the implemented UI against the agreed direction.
EOF
python3 - <<'PY'
from pathlib import Path
p=Path('lib/core/app_controller.dart')
s=p.read_text()
s=s.replace("    'today': {", "    'add_class': {AppLanguage.en: 'Add class', AppLanguage.bn: 'ক্লাস যোগ করো', AppLanguage.hi: 'कक्षा जोड़ें'},\n    'no_classes': {AppLanguage.en: 'No classes for this day yet.', AppLanguage.bn: 'এই দিনে এখনও কোনো ক্লাস নেই।', AppLanguage.hi: 'इस दिन अभी कोई कक्षा नहीं है।'},\n    'routine_tip': {AppLanguage.en: 'Your routine is a plan. Attendance is only counted after you record a class that actually happened.', AppLanguage.bn: 'রুটিন হলো পরিকল্পনা। বাস্তবে ক্লাস হওয়ার পর উপস্থিতি যোগ হবে।', AppLanguage.hi: 'रूटीन एक योजना है। उपस्थिति केवल वास्तविक कक्षा दर्ज करने पर गिनी जाएगी।'},\n    'add_subject': {AppLanguage.en: 'Add subject', AppLanguage.bn: 'বিষয় যোগ করো', AppLanguage.hi: 'विषय जोड़ें'},\n    'subject_name': {AppLanguage.en: 'Subject name', AppLanguage.bn: 'বিষয়ের নাম', AppLanguage.hi: 'विषय का नाम'},\n    'overall_attendance': {AppLanguage.en: 'Overall attendance', AppLanguage.bn: 'সামগ্রিক উপস্থিতি', AppLanguage.hi: 'कुल उपस्थिति'},\n    'of': {AppLanguage.en: 'of', AppLanguage.bn: 'এর মধ্যে', AppLanguage.hi: 'में से'},\n    'classes_attended': {AppLanguage.en: 'classes attended', AppLanguage.bn: 'টি ক্লাসে উপস্থিত', AppLanguage.hi: 'कक्षाओं में उपस्थित'},\n    'attendance_disclaimer': {AppLanguage.en: 'An estimate based on the classes you record. This is not an official college attendance record.', AppLanguage.bn: 'তোমার দেওয়া তথ্যের ভিত্তিতে হিসাব। এটি কলেজের অফিসিয়াল উপস্থিতির রেকর্ড নয়।', AppLanguage.hi: 'यह आपके दर्ज किए गए डेटा का अनुमान है, कॉलेज का आधिकारिक रिकॉर्ड नहीं।'},\n    'current_attendance': {AppLanguage.en: 'Current attendance', AppLanguage.bn: 'বর্তমান উপস্থিতি', AppLanguage.hi: 'वर्तमान उपस्थिति'},\n    'safe_misses': {AppLanguage.en: 'Maximum classes you can miss', AppLanguage.bn: 'সর্বোচ্চ যত ক্লাস মিস করা যায়', AppLanguage.hi: 'अधिकतम कक्षाएँ जिन्हें छोड़ सकते हैं'},\n    'classes_to_target': {AppLanguage.en: 'Classes to reach your target', AppLanguage.bn: 'লক্ষ্যে পৌঁছাতে যত ক্লাস দরকার', AppLanguage.hi: 'लक्ष्य तक पहुँचने के लिए कक्षाएँ'},\n    'classes_in_a_row': {AppLanguage.en: 'classes in a row', AppLanguage.bn: 'টি ক্লাস টানা', AppLanguage.hi: 'लगातार कक्षाएँ'},\n    'recent_sessions': {AppLanguage.en: 'Recent sessions', AppLanguage.bn: 'সাম্প্রতিক ক্লাস', AppLanguage.hi: 'हाल की कक्षाएँ'},\n    'session_history_empty': {AppLanguage.en: 'Class history will appear here as you record attendance.', AppLanguage.bn: 'উপস্থিতি যোগ করলে ক্লাসের ইতিহাস এখানে দেখা যাবে।', AppLanguage.hi: 'उपस्थिति दर्ज करने पर कक्षा का इतिहास यहाँ दिखेगा।'},\n    'tasks_subtitle': {AppLanguage.en: 'Assignments, quizzes, and exams—without the last-minute rush.', AppLanguage.bn: 'অ্যাসাইনমেন্ট, কুইজ ও পরীক্ষা—শেষ মুহূর্তের তাড়া ছাড়াই।', AppLanguage.hi: 'असाइनमेंट, क्विज़ और परीक्षाएँ—बिना आख़िरी समय की भागदौड़।'},\n    'preferences': {AppLanguage.en: 'Preferences', AppLanguage.bn: 'পছন্দ', AppLanguage.hi: 'प्राथमिकताएँ'},\n    'target_note': {AppLanguage.en: 'Used to calculate subject status. Set a different target only if your institution requires it.', AppLanguage.bn: 'বিষয়ের উপস্থিতির অবস্থা হিসাব করতে ব্যবহৃত হয়।', AppLanguage.hi: 'विषय की स्थिति की गणना में उपयोग होता है।'},\n    'about': {AppLanguage.en: 'About', AppLanguage.bn: 'অ্যাপ সম্পর্কে', AppLanguage.hi: 'ऐप के बारे में'},\n    'offline_privacy_note': {AppLanguage.en: 'Your planner data stays on this device in this prototype. No account is required.', AppLanguage.bn: 'এই প্রোটোটাইপে তোমার তথ্য এই ডিভাইসেই থাকে। অ্যাকাউন্ট প্রয়োজন নেই।', AppLanguage.hi: 'इस प्रोटोटाइप में आपका डेटा इसी डिवाइस पर रहता है। अकाउंट की ज़रूरत नहीं।'},\n    'choose_language': {AppLanguage.en: 'Choose the language you want to use in the app.', AppLanguage.bn: 'অ্যাপে যে ভাষা ব্যবহার করতে চাও সেটি বেছে নাও।', AppLanguage.hi: 'ऐप में अपनी पसंद की भाषा चुनें।'},\n    'language_data_note': {AppLanguage.en: 'Changing the app language does not change the subject or task names you entered.', AppLanguage.bn: 'অ্যাপের ভাষা বদলালেও তোমার লেখা বিষয় বা কাজের নাম বদলাবে না।', AppLanguage.hi: 'ऐप की भाषा बदलने से आपके लिखे विषय या काम के नाम नहीं बदलेंगे।'},\n    'setup_title': {AppLanguage.en: 'Your subjects, your semester', AppLanguage.bn: 'তোমার বিষয়, তোমার সেমেস্টার', AppLanguage.hi: 'आपके विषय, आपका सेमेस्टर'},\n    'setup_subtitle': {AppLanguage.en: 'Add the subjects you want to track. You can update this list anytime.', AppLanguage.bn: 'যে বিষয়গুলোর হিসাব রাখতে চাও সেগুলো যোগ করো। পরে বদলানো যাবে।', AppLanguage.hi: 'जिन विषयों को ट्रैक करना है उन्हें जोड़ें। सूची बाद में बदल सकते हैं।'},\n    'setup_tip': {AppLanguage.en: 'ClassBondhu calculates attendance only from classes you mark as held—not from the weekly timetable.', AppLanguage.bn: 'সাপ্তাহিক রুটিন নয়, বাস্তবে হওয়া ক্লাসের উপস্থিতি থেকেই হিসাব হবে।', AppLanguage.hi: 'गणना साप्ताहिक रूटीन से नहीं, दर्ज की गई वास्तविक कक्षाओं से होगी।'},\n    'done': {AppLanguage.en: 'Done', AppLanguage.bn: 'সম্পন্ন', AppLanguage.hi: 'हो गया'},\n    'task_title_hint': {AppLanguage.en: 'e.g. Submit chapter 4 worksheet', AppLanguage.bn: 'যেমন: অধ্যায় ৪-এর কাজ জমা', AppLanguage.hi: 'जैसे: अध्याय 4 की वर्कशीट जमा करें'},\n    'task_type': {AppLanguage.en: 'Task type', AppLanguage.bn: 'কাজের ধরন', AppLanguage.hi: 'काम का प्रकार'},\n    'no_subject': {AppLanguage.en: 'No subject', AppLanguage.bn: 'বিষয় নেই', AppLanguage.hi: 'कोई विषय नहीं'},\n    'details_optional': {AppLanguage.en: 'Details (optional)', AppLanguage.bn: 'বিস্তারিত (ঐচ্ছিক)', AppLanguage.hi: 'विवरण (वैकल्पिक)'},\n    'reminder_hint': {AppLanguage.en: 'A reminder before the due date', AppLanguage.bn: 'জমার আগে মনে করিয়ে দেবে', AppLanguage.hi: 'जमा करने से पहले याद दिलाएँ'},\n    'no_due_date': {AppLanguage.en: 'No due date', AppLanguage.bn: 'তারিখ দেওয়া হয়নি', AppLanguage.hi: 'तारीख़ नहीं दी'},\n    'today': {")
p.write_text(s)
PY
