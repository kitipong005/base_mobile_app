import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';
import '../../core/constants/hive_boxes.dart';

@singleton
class LocalDataSource {
  Box<UserModel> get _userBox => Hive.box<UserModel>(HiveBoxes.users);
  Box get _settingsBox => Hive.box(HiveBoxes.settings);

  Future<void> saveUser(UserModel user) async {
    await _userBox.put(user.id, user);
  }

  UserModel? getUser(String id) {
    return _userBox.get(id);
  }

  List<UserModel> getAllUsers() {
    return _userBox.values.toList();
  }

  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  T? getSetting<T>(String key) {
    return _settingsBox.get(key);
  }
}