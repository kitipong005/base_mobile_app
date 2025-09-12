import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/auth_models.dart';
import '../../core/constants/hive_boxes.dart';
import '../../core/config/app_config.dart';
import '../../core/constants/api_endpoints.dart';

@singleton
class AuthRepository {
  final Dio _dio;
  late final Box<AuthToken> _authBox;
  late final Box _userBox;

  AuthRepository(this._dio) {
    _authBox = Hive.box<AuthToken>(HiveBoxes.auth);
    _userBox = Hive.box(HiveBoxes.userData); // Using separate box for user data
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}${ApiEndpoints.login}',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      
      if (loginResponse.isSuccess  && loginResponse.token != null) {
        await _saveAuthToken(loginResponse.token!);
        if (loginResponse.user != null) {
          await _saveUserData(loginResponse.user!);
        }
      }
      
      return loginResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        return LoginResponse.fromJson(e.response!.data);
      }
      return const LoginResponse(
        success: false,
        message: 'Network error occurred',
      );
    } catch (e) {
      return const LoginResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  Future<void> _saveAuthToken(String token) async {
    final authToken = AuthToken(
      token: token,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
    await _authBox.put('current_token', authToken);
  }

  Future<void> _saveUserData(UserData user) async {
    await _userBox.put('current_user', user.toJson());
  }

  AuthToken? getSavedAuthToken() {
    final token = _authBox.get('current_token');
    if (token != null && !token.isExpired) {
      return token;
    }
    return null;
  }

  UserData? getSavedUserData() {
    final userData = _userBox.get('current_user');
    if (userData != null) {
      return UserData.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  Future<void> logout() async {
    await _authBox.delete('current_token');
    await _userBox.delete('current_user');
  }

  bool get isAuthenticated {
    final token = getSavedAuthToken();
    return token != null && !token.isExpired;
  }
}