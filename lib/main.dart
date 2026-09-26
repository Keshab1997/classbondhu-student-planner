import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_controller.dart';
import 'core/app_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await AppController.open(SqliteAppStorage());
  runApp(ClassBondhuApp(controller: controller));
}
