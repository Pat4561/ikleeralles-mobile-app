class Registration {

  final String username;
  final String password;
  final String email;

  Registration ({ this.username, this.password, this.email });

}

class TeacherRegistration extends Registration {


  TeacherRegistration ({ String username, String password, String email }) : super(
      username: username, password: password, email: email
  );

}

class ScholarRegistration extends Registration {

  final String level;
  final int year;

  ScholarRegistration ({ String username, String password, String email, this.level, this.year }) : super(
      username: username,
      password: password,
      email: email
  );

}
