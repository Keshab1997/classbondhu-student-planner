import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/app_theme.dart';

class PageGutter extends StatelessWidget {
  const PageGutter({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: child,
      );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.title, this.action, this.onAction, super.key});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
          if (action != null)
            onAction == null
                ? Text(action!, style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700))
                : TextButton(onPressed: onAction, child: Text(action!, style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700)),),
        ],
      );
}

class SoftIcon extends StatelessWidget {
  const SoftIcon(this.icon, {this.color = AppColors.brand, this.background = AppColors.paleBlue, this.size = 44, super.key});
  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(size * .34)),
        child: Icon(icon, color: color, size: size * .5),
      );
}

class WhitePanel extends StatelessWidget {
  const WhitePanel({required this.child, this.padding = const EdgeInsets.all(18), this.onTap, super.key});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.line.withOpacity(.82)),
              boxShadow: const [BoxShadow(color: Color(0x080E1733), blurRadius: 22, offset: Offset(0, 8))],
            ),
            child: child,
          ),
        ),
      );
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.text, this.good = true, super.key});
  final String text;
  final bool good;

  @override
  Widget build(BuildContext context) {
    final color = good ? AppColors.mint : const Color(0xFFE1973E);
    final bg = good ? AppColors.paleMint : AppColors.paleAmber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(40)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(good ? Icons.check_circle_rounded : Icons.info_rounded, size: 14, color: color),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class AppDate {
  static String today(AppLanguage language) {
    final now = DateTime.now();
    const enDays = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
    const bnDays = ['সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার', 'রবিবার'];
    const hiDays = ['सोमवार', 'मंगलवार', 'बुधवार', 'गुरुवार', 'शुक्रवार', 'शनिवार', 'रविवार'];
    const enMonths = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    const bnMonths = ['জানু', 'ফেব্রু', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগ', 'সেপ্টে', 'অক্টো', 'নভে', 'ডিসে'];
    const hiMonths = ['जन', 'फ़र', 'मार्च', 'अप्रै', 'मई', 'जून', 'जुला', 'अग', 'सित', 'अक्टू', 'नव', 'दिस'];
    final day = switch (language) { AppLanguage.en => enDays, AppLanguage.bn => bnDays, AppLanguage.hi => hiDays };
    final month = switch (language) { AppLanguage.en => enMonths, AppLanguage.bn => bnMonths, AppLanguage.hi => hiMonths };
    return '${day[now.weekday - 1]}, ${now.day} ${month[now.month - 1]}';
  }
}

