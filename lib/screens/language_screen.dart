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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(tr(language, 'choose_language'), style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 17),
          ...AppLanguage.values.map((option) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: WhitePanel(
                  onTap: () {
                    controller.setLanguage(option);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            option == AppLanguage.bn ? 'অ' : option == AppLanguage.hi ? 'अ' : 'A',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.brand),
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.nativeName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                            const SizedBox(height: 3),
                            Text(option.label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (language == option) const Icon(Icons.check_circle_rounded, color: AppColors.brand),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 6),
          Text(tr(language, 'language_data_note'), style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}
