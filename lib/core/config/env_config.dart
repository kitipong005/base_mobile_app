import 'package:flutter_dotenv/flutter_dotenv.dart';
class EnvConfig {
  late final String apiKey;
  late final String baseUrl;
  late final String loginUrl;
  void setup(DotEnv dotenv) {
    apiKey = dotenv.env['API_KEY'] ?? '';
    baseUrl = dotenv.env['BASE_URL'] ?? '';
    loginUrl = dotenv.env['LOGIN_URL'] ?? '';
  }
}