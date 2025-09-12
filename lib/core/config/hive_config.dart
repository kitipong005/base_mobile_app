import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../constants/hive_boxes.dart';
import '../../data/models/user_model.dart';
import '../../data/models/auth_models.dart';

@singleton
class HiveConfig {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(AuthTokenAdapter());
    
    await Hive.openBox<UserModel>(HiveBoxes.users);
    await Hive.openBox(HiveBoxes.settings);
    await Hive.openBox<AuthToken>(HiveBoxes.auth);
    await Hive.openBox(HiveBoxes.userData);
  }
}