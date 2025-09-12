import 'core/config/app_config.dart';
import 'main_common.dart';

void main() {
  AppConfig.flavor = Flavor.prod;
  mainCommon();
}