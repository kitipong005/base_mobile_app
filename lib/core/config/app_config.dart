enum Flavor { dev, staging, prod }

class AppConfig {
  static Flavor flavor = Flavor.dev;
  static String get baseUrl {
    switch (flavor) {
      case Flavor.dev:
        return 'https://web-admin-base.vercel.app/api';
      case Flavor.staging:
        return 'https://api-staging.moonoi.com/api';
      case Flavor.prod:
        return 'https://api.moonoi.com/api';
    }
  }

  static String get appName {
    switch (flavor) {
      case Flavor.dev:
        return 'Base Mobile App (Dev)';
      case Flavor.staging:
        return 'Base Mobile App (Staging)';
      case Flavor.prod:
        return 'Base Mobile App';
    }
  }

  static bool get isDebug => flavor != Flavor.prod;
}