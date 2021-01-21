import 'package:ikleeralles/network/keys.dart';

abstract class Registration {

  final String username;
  final String password;
  final String email;

  Registration ({ this.username, this.password, this.email });


  String get role;

  Map<String, dynamic> toMap() {
    return {
      AuthKeys.username: username,
      AuthKeys.password: password,
      UserInfoKeys.email: email,
      UserInfoKeys.role: role,
      UserInfoKeys.year: 1,
      UserInfoKeys.level: "havo",
      UserInfoKeys.refferal: ""
    };
  }

}

class TeacherRegistration extends Registration {


  TeacherRegistration ({ String username, String password, String email }) : super(
      username: username, password: password, email: email
  );

  @override
  String get role => "teacher";

}

class ScholarRegistration extends Registration {

  final String level;
  final int year;

  ScholarRegistration ({ String username, String password, String email, this.level, this.year }) : super(
      username: username,
      password: password,
      email: email
  );

  @override
  String get role => "student";

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map[UserInfoKeys.level] = level;
    map[UserInfoKeys.year] = year;
    return map;
  }

}
