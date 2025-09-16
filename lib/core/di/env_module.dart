import 'package:base_mobile_app/core/config/env_config.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@module
abstract class EnvModule {
  @preResolve
  Future<EnvConfig> provideEnv() async {
    await dotenv.load(fileName: ".env");
    final env = EnvConfig();
    env.setup(dotenv);
    return env;
  }
}