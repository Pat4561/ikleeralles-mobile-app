class ApiUrl {

  final Map<String, String> requestParams;
  final String route;

  static String host = "http://localhost:3000";

  ApiUrl (this.route, { this.requestParams });

  @override
  String toString() {
    return "$host/$route";
  }
}
