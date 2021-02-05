import 'dart:io' show Platform;

enum EnvironmentType {
  iOS,
  android,
  unknown
}

class Environment {


  static String asString(EnvironmentType type) {
    if (type == EnvironmentType.iOS) {
      return "iOS";
    } else if (type == EnvironmentType.android) {
      return "android";
    } else if (type == EnvironmentType.unknown) {
      return "unknown";
    }
    return "unknown";
  }


  static EnvironmentType get() {
    EnvironmentType type = EnvironmentType.unknown;
    if (Platform.isAndroid) {
      type = EnvironmentType.android;
    } else if (Platform.isIOS) {
      type = EnvironmentType.iOS;
    }
    return type;
  }

}