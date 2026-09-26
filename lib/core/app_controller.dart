import 'package:flutter/material.dart';

enum AppLanguage { en, bn, hi }

extension AppLanguageLabel on AppLanguage {
  String get label => switch (this) {
        AppLanguage.en => 'English',
        AppLanguage.bn => 'বাংলা',
        AppLanguage.hi => 'हिन्दी',
      };

  String get nativeName => switch (this) {
        AppLanguage.en => 'English',
        AppLanguage.bn => 'বাংলা',
        AppLanguage.hi => 'हिन्दी',
      };
}

class SubjectData {
  SubjectData({
    required this.id,
    required this.name,
    required this.attended,
    required this.conducted,
    required this.color,
    this.room = '',
  });

  final String id;
  final String name;
  int attended;
  int conducted;
  final int color;
  final String room;

  double get percentage => conducted == 0 ? 0 : attended / conducted;
}

class TaskData {
  TaskData({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueLabel,
    required this.type,
    this.done = false,
  });

  final String id;
  final String title;
  final String subject;
  final String dueLabel;
  final String type;
  bool done;
}

class AppController extends ChangeNotifier {
  AppLanguage language = AppLanguage.en;
  int attendanceTarget = 75;

  final List<SubjectData> subjects = [
    SubjectData(
      id: 'math', name: 'Mathematics', attended: 9, conducted: 11,
      color: 0xFF6675E8, room: 'Room 204',
    ),
    SubjectData(
      id: 'physics', name: 'Physics', attended: 7, conducted: 9,
      color: 0xFF39BFA4, room: 'Lab 2',
    ),
    SubjectData(
      id: 'english', name: 'English', attended: 12, conducted: 13,
      color: 0xFFF0A65B, room: 'Room 108',
    ),
  ];

  final Map<String, bool> todayAttendance = {};

  final List<TaskData> tasks = [
    TaskData(
      id: 'task-1', title: 'Physics assignment', subject: 'Physics',
      dueLabel: 'Tomorrow · 10:00 AM', type: 'Assignment',
    ),
    TaskData(
      id: 'task-2', title: 'Linear algebra quiz', subject: 'Mathematics',
      dueLabel: 'Thu · 9:00 AM', type: 'Quiz',
    ),
    TaskData(
      id: 'task-3', title: 'Lab report: motion', subject: 'Physics',
      dueLabel: 'Fri · 4:00 PM', type: 'Assignment', done: true,
    ),
  ];

  void setLanguage(AppLanguage value) {
    language = value;
    notifyListeners();
  }

  void setTarget(int value) {
    attendanceTarget = value;
    notifyListeners();
  }

  void markAttendance(String subjectId, {required bool present}) {
    final subject = subjects.firstWhere((item) => item.id == subjectId);
    if (todayAttendance.containsKey(subjectId)) return;
    subject.conducted += 1;
    if (present) subject.attended += 1;
    todayAttendance[subjectId] = present;
    notifyListeners();
  }

  void toggleTask(String id) {
    final task = tasks.firstWhere((item) => item.id == id);
    task.done = !task.done;
    notifyListeners();
  }

  void addTask({
    required String title,
    required String subject,
    required String dueLabel,
    required String type,
  }) {
    tasks.insert(0, TaskData(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      subject: subject,
      dueLabel: dueLabel,
      type: type,
    ));
    notifyListeners();
  }

  void addSubject(String name) {
    if (name.trim().isEmpty) return;
    subjects.add(SubjectData(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(), attended: 0, conducted: 0,
      color: 0xFF8A6FE8,
    ));
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    required AppController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this widget.');
    return scope!.notifier!;
  }
}

String tr(AppLanguage language, String key) {
  const copy = <String, Map<AppLanguage, String>>{
    'add_class': {AppLanguage.en: 'Add class', AppLanguage.bn: 'ক্লাস যোগ করো', AppLanguage.hi: 'कक्षा जोड़ें'},
    'no_classes': {AppLanguage.en: 'No classes for this day yet.', AppLanguage.bn: 'এই দিনে এখনও কোনো ক্লাস নেই।', AppLanguage.hi: 'इस दिन अभी कोई कक्षा नहीं है।'},
    'routine_tip': {AppLanguage.en: 'Your routine is a plan. Attendance is only counted after you record a class that actually happened.', AppLanguage.bn: 'রুটিন হলো পরিকল্পনা। বাস্তবে ক্লাস হওয়ার পর উপস্থিতি যোগ হবে।', AppLanguage.hi: 'रूटीन एक योजना है। उपस्थिति केवल वास्तविक कक्षा दर्ज करने पर गिनी जाएगी।'},
    'add_subject': {AppLanguage.en: 'Add subject', AppLanguage.bn: 'বিষয় যোগ করো', AppLanguage.hi: 'विषय जोड़ें'},
    'subject_name': {AppLanguage.en: 'Subject name', AppLanguage.bn: 'বিষয়ের নাম', AppLanguage.hi: 'विषय का नाम'},
    'overall_attendance': {AppLanguage.en: 'Overall attendance', AppLanguage.bn: 'সামগ্রিক উপস্থিতি', AppLanguage.hi: 'कुल उपस्थिति'},
    'of': {AppLanguage.en: 'of', AppLanguage.bn: 'এর মধ্যে', AppLanguage.hi: 'में से'},
    'classes_attended': {AppLanguage.en: 'classes attended', AppLanguage.bn: 'টি ক্লাসে উপস্থিত', AppLanguage.hi: 'कक्षाओं में उपस्थित'},
    'attendance_disclaimer': {AppLanguage.en: 'An estimate based on the classes you record. This is not an official college attendance record.', AppLanguage.bn: 'তোমার দেওয়া তথ্যের ভিত্তিতে হিসাব। এটি কলেজের অফিসিয়াল উপস্থিতির রেকর্ড নয়।', AppLanguage.hi: 'यह आपके दर्ज किए गए डेटा का अनुमान है, कॉलेज का आधिकारिक रिकॉर्ड नहीं।'},
    'no_attendance_yet': {AppLanguage.en: 'No classes recorded yet', AppLanguage.bn: 'এখনও কোনো ক্লাসের তথ্য নেই', AppLanguage.hi: 'अभी कोई कक्षा दर्ज नहीं'},
    'attend_every_class': {AppLanguage.en: 'Attend every future class to reach 100%', AppLanguage.bn: '১০০% পেতে ভবিষ্যতের সব ক্লাসে উপস্থিত থাকতে হবে', AppLanguage.hi: '100% के लिए आगे की हर कक्षा में उपस्थित रहें'},
    'current_attendance': {AppLanguage.en: 'Current attendance', AppLanguage.bn: 'বর্তমান উপস্থিতি', AppLanguage.hi: 'वर्तमान उपस्थिति'},
    'safe_misses': {AppLanguage.en: 'Maximum classes you can miss', AppLanguage.bn: 'সর্বোচ্চ যত ক্লাস মিস করা যায়', AppLanguage.hi: 'अधिकतम कक्षाएँ जिन्हें छोड़ सकते हैं'},
    'classes_to_target': {AppLanguage.en: 'Classes to reach your target', AppLanguage.bn: 'লক্ষ্যে পৌঁছাতে যত ক্লাস দরকার', AppLanguage.hi: 'लक्ष्य तक पहुँचने के लिए कक्षाएँ'},
    'classes_in_a_row': {AppLanguage.en: 'classes in a row', AppLanguage.bn: 'টি ক্লাস টানা', AppLanguage.hi: 'लगातार कक्षाएँ'},
    'recent_sessions': {AppLanguage.en: 'Recent sessions', AppLanguage.bn: 'সাম্প্রতিক ক্লাস', AppLanguage.hi: 'हाल की कक्षाएँ'},
    'session_history_empty': {AppLanguage.en: 'Class history will appear here as you record attendance.', AppLanguage.bn: 'উপস্থিতি যোগ করলে ক্লাসের ইতিহাস এখানে দেখা যাবে।', AppLanguage.hi: 'उपस्थिति दर्ज करने पर कक्षा का इतिहास यहाँ दिखेगा।'},
    'tasks_subtitle': {AppLanguage.en: 'Assignments, quizzes, and exams—without the last-minute rush.', AppLanguage.bn: 'অ্যাসাইনমেন্ট, কুইজ ও পরীক্ষা—শেষ মুহূর্তের তাড়া ছাড়াই।', AppLanguage.hi: 'असाइनमेंट, क्विज़ और परीक्षाएँ—बिना आख़िरी समय की भागदौड़।'},
    'preferences': {AppLanguage.en: 'Preferences', AppLanguage.bn: 'পছন্দ', AppLanguage.hi: 'प्राथमिकताएँ'},
    'target_note': {AppLanguage.en: 'Used to calculate subject status. Set a different target only if your institution requires it.', AppLanguage.bn: 'বিষয়ের উপস্থিতির অবস্থা হিসাব করতে ব্যবহৃত হয়।', AppLanguage.hi: 'विषय की स्थिति की गणना में उपयोग होता है।'},
    'about': {AppLanguage.en: 'About', AppLanguage.bn: 'অ্যাপ সম্পর্কে', AppLanguage.hi: 'ऐप के बारे में'},
    'offline_privacy_note': {AppLanguage.en: 'Your planner data stays on this device in this prototype. No account is required.', AppLanguage.bn: 'এই প্রোটোটাইপে তোমার তথ্য এই ডিভাইসেই থাকে। অ্যাকাউন্ট প্রয়োজন নেই।', AppLanguage.hi: 'इस प्रोटोटाइप में आपका डेटा इसी डिवाइस पर रहता है। अकाउंट की ज़रूरत नहीं।'},
    'choose_language': {AppLanguage.en: 'Choose the language you want to use in the app.', AppLanguage.bn: 'অ্যাপে যে ভাষা ব্যবহার করতে চাও সেটি বেছে নাও।', AppLanguage.hi: 'ऐप में अपनी पसंद की भाषा चुनें।'},
    'language_data_note': {AppLanguage.en: 'Changing the app language does not change the subject or task names you entered.', AppLanguage.bn: 'অ্যাপের ভাষা বদলালেও তোমার লেখা বিষয় বা কাজের নাম বদলাবে না।', AppLanguage.hi: 'ऐप की भाषा बदलने से आपके लिखे विषय या काम के नाम नहीं बदलेंगे।'},
    'setup_title': {AppLanguage.en: 'Your subjects, your semester', AppLanguage.bn: 'তোমার বিষয়, তোমার সেমেস্টার', AppLanguage.hi: 'आपके विषय, आपका सेमेस्टर'},
    'setup_subtitle': {AppLanguage.en: 'Add the subjects you want to track. You can update this list anytime.', AppLanguage.bn: 'যে বিষয়গুলোর হিসাব রাখতে চাও সেগুলো যোগ করো। পরে বদলানো যাবে।', AppLanguage.hi: 'जिन विषयों को ट्रैक करना है उन्हें जोड़ें। सूची बाद में बदल सकते हैं।'},
    'setup_tip': {AppLanguage.en: 'ClassBondhu calculates attendance only from classes you mark as held—not from the weekly timetable.', AppLanguage.bn: 'সাপ্তাহিক রুটিন নয়, বাস্তবে হওয়া ক্লাসের উপস্থিতি থেকেই হিসাব হবে।', AppLanguage.hi: 'गणना साप्ताहिक रूटीन से नहीं, दर्ज की गई वास्तविक कक्षाओं से होगी।'},
    'done': {AppLanguage.en: 'Done', AppLanguage.bn: 'সম্পন্ন', AppLanguage.hi: 'हो गया'},
    'task_title_hint': {AppLanguage.en: 'e.g. Submit chapter 4 worksheet', AppLanguage.bn: 'যেমন: অধ্যায় ৪-এর কাজ জমা', AppLanguage.hi: 'जैसे: अध्याय 4 की वर्कशीट जमा करें'},
    'task_type': {AppLanguage.en: 'Task type', AppLanguage.bn: 'কাজের ধরন', AppLanguage.hi: 'काम का प्रकार'},
    'no_subject': {AppLanguage.en: 'No subject', AppLanguage.bn: 'বিষয় নেই', AppLanguage.hi: 'कोई विषय नहीं'},
    'details_optional': {AppLanguage.en: 'Details (optional)', AppLanguage.bn: 'বিস্তারিত (ঐচ্ছিক)', AppLanguage.hi: 'विवरण (वैकल्पिक)'},
    'reminder_hint': {AppLanguage.en: 'A reminder before the due date', AppLanguage.bn: 'জমার আগে মনে করিয়ে দেবে', AppLanguage.hi: 'जमा करने से पहले याद दिलाएँ'},
    'no_due_date': {AppLanguage.en: 'No due date', AppLanguage.bn: 'তারিখ দেওয়া হয়নি', AppLanguage.hi: 'तारीख़ नहीं दी'},
    'today': {AppLanguage.en: 'Today', AppLanguage.bn: 'আজ', AppLanguage.hi: 'आज'},
    'routine': {AppLanguage.en: 'Routine', AppLanguage.bn: 'রুটিন', AppLanguage.hi: 'रूटीन'},
    'attendance': {AppLanguage.en: 'Attendance', AppLanguage.bn: 'উপস্থিতি', AppLanguage.hi: 'उपस्थिति'},
    'tasks': {AppLanguage.en: 'Tasks', AppLanguage.bn: 'কাজ', AppLanguage.hi: 'काम'},
    'good_morning': {AppLanguage.en: 'Good morning', AppLanguage.bn: 'সুপ্রভাত', AppLanguage.hi: 'सुप्रभात'},
    'focused_day': {AppLanguage.en: 'Ready for a focused day?', AppLanguage.bn: 'আজকের দিনটা গুছিয়ে শুরু করি?', AppLanguage.hi: 'आज का दिन अच्छे से शुरू करें?'},
    'your_attendance': {AppLanguage.en: 'Your attendance', AppLanguage.bn: 'তোমার উপস্থিতি', AppLanguage.hi: 'आपकी उपस्थिति'},
    'target': {AppLanguage.en: 'Target', AppLanguage.bn: 'লক্ষ্য', AppLanguage.hi: 'लक्ष्य'},
    'on_track': {AppLanguage.en: "You're on track", AppLanguage.bn: 'লক্ষ্য ঠিক আছে', AppLanguage.hi: 'आप सही राह पर हैं'},
    'today_classes': {AppLanguage.en: "Today's classes", AppLanguage.bn: 'আজকের ক্লাস', AppLanguage.hi: 'आज की कक्षाएँ'},
    'see_all': {AppLanguage.en: 'See all', AppLanguage.bn: 'সব দেখো', AppLanguage.hi: 'सभी देखें'},
    'present': {AppLanguage.en: 'Present', AppLanguage.bn: 'উপস্থিত', AppLanguage.hi: 'उपस्थित'},
    'absent': {AppLanguage.en: 'Absent', AppLanguage.bn: 'অনুপস্থিত', AppLanguage.hi: 'अनुपस्थित'},
    'mark_attendance': {AppLanguage.en: 'Mark attendance', AppLanguage.bn: 'উপস্থিতি দাও', AppLanguage.hi: 'उपस्थिति दर्ज करें'},
    'due_tomorrow': {AppLanguage.en: 'Due tomorrow', AppLanguage.bn: 'জমা কাল', AppLanguage.hi: 'कल जमा करें'},
    'up_next': {AppLanguage.en: 'Up next', AppLanguage.bn: 'পরের ক্লাস', AppLanguage.hi: 'अगली कक्षा'},
    'this_week': {AppLanguage.en: 'This week', AppLanguage.bn: 'এই সপ্তাহ', AppLanguage.hi: 'इस सप्ताह'},
    'subjects': {AppLanguage.en: 'Subjects', AppLanguage.bn: 'বিষয়', AppLanguage.hi: 'विषय'},
    'classes': {AppLanguage.en: 'classes', AppLanguage.bn: 'টি ক্লাস', AppLanguage.hi: 'कक्षाएँ'},
    'attendance_summary': {AppLanguage.en: 'Attendance summary', AppLanguage.bn: 'উপস্থিতির সারাংশ', AppLanguage.hi: 'उपस्थिति सारांश'},
    'all_subjects': {AppLanguage.en: 'All subjects', AppLanguage.bn: 'সব বিষয়', AppLanguage.hi: 'सभी विषय'},
    'on_track_status': {AppLanguage.en: 'On track', AppLanguage.bn: 'লক্ষ্যে আছো', AppLanguage.hi: 'लक्ष्य पर'},
    'needs_attention': {AppLanguage.en: 'Needs attention', AppLanguage.bn: 'খেয়াল দরকার', AppLanguage.hi: 'ध्यान दें'},
    'upcoming': {AppLanguage.en: 'Upcoming', AppLanguage.bn: 'আসন্ন', AppLanguage.hi: 'आने वाले'},
    'completed': {AppLanguage.en: 'Completed', AppLanguage.bn: 'সম্পন্ন', AppLanguage.hi: 'पूरे हुए'},
    'add_task': {AppLanguage.en: 'Add task', AppLanguage.bn: 'কাজ যোগ করো', AppLanguage.hi: 'काम जोड़ें'},
    'assignment': {AppLanguage.en: 'Assignment', AppLanguage.bn: 'অ্যাসাইনমেন্ট', AppLanguage.hi: 'असाइनमेंट'},
    'quiz': {AppLanguage.en: 'Quiz', AppLanguage.bn: 'কুইজ', AppLanguage.hi: 'क्विज़'},
    'exam': {AppLanguage.en: 'Exam', AppLanguage.bn: 'পরীক্ষা', AppLanguage.hi: 'परीक्षा'},
    'other': {AppLanguage.en: 'Other', AppLanguage.bn: 'অন্যান্য', AppLanguage.hi: 'अन्य'},
    'settings': {AppLanguage.en: 'Settings', AppLanguage.bn: 'সেটিংস', AppLanguage.hi: 'सेटिंग्स'},
    'language': {AppLanguage.en: 'App language', AppLanguage.bn: 'অ্যাপের ভাষা', AppLanguage.hi: 'ऐप की भाषा'},
    'attendance_target': {AppLanguage.en: 'Default attendance target', AppLanguage.bn: 'ডিফল্ট উপস্থিতির লক্ষ্য', AppLanguage.hi: 'डिफ़ॉल्ट उपस्थिति लक्ष्य'},
    'edit_subjects': {AppLanguage.en: 'Edit subjects', AppLanguage.bn: 'বিষয় সম্পাদনা', AppLanguage.hi: 'विषय बदलें'},
    'save': {AppLanguage.en: 'Save', AppLanguage.bn: 'সংরক্ষণ', AppLanguage.hi: 'सहेजें'},
    'cancel': {AppLanguage.en: 'Cancel', AppLanguage.bn: 'বাতিল', AppLanguage.hi: 'रद्द करें'},
    'title': {AppLanguage.en: 'Title', AppLanguage.bn: 'শিরোনাম', AppLanguage.hi: 'शीर्षक'},
    'subject': {AppLanguage.en: 'Subject', AppLanguage.bn: 'বিষয়', AppLanguage.hi: 'विषय'},
    'due_date': {AppLanguage.en: 'Due date', AppLanguage.bn: 'জমা দেওয়ার তারিখ', AppLanguage.hi: 'जमा करने की तारीख'},
    'reminder': {AppLanguage.en: 'Reminder', AppLanguage.bn: 'রিমাইন্ডার', AppLanguage.hi: 'रिमाइंडर'},
    'no_tasks': {AppLanguage.en: 'Nothing due here', AppLanguage.bn: 'এখানে কোনো কাজ নেই', AppLanguage.hi: 'यहाँ कुछ बाकी नहीं'},
    'today_label': {AppLanguage.en: 'TODAY', AppLanguage.bn: 'আজ', AppLanguage.hi: 'आज'},
    'weekly_routine': {AppLanguage.en: 'Weekly routine', AppLanguage.bn: 'সাপ্তাহিক রুটিন', AppLanguage.hi: 'साप्ताहिक रूटीन'},
    'hello': {AppLanguage.en: 'Hello, Ananya', AppLanguage.bn: 'হ্যালো, আনন্যা', AppLanguage.hi: 'नमस्ते, अनन्या'},
    'profile': {AppLanguage.en: 'Profile & preferences', AppLanguage.bn: 'প্রোফাইল ও পছন্দ', AppLanguage.hi: 'प्रोफ़ाइल और पसंद'},
  };
  return copy[key]?[language] ?? key;
}
