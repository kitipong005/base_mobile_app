import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/config/hive_config.dart';
import 'presentation/app.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveConfig.init();
  configureDependencies();
  
  runApp(const App());
}