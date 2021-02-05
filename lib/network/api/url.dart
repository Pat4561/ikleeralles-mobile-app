class ApiUrl {

  final Map<String, String> requestParams;
  final String route;

  static String host = "http://f50ef49b948e.ngrok.io";

  ApiUrl (this.route, { this.requestParams });

  @override
  String toString() {
    return "$host/$route";
  }
}
