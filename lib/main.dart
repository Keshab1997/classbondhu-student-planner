import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_controller.dart';
import 'core/app_storage_factory.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await AppController.open(createAppStorage());
  runApp(ClassBondhuApp(controller: controller));
}
