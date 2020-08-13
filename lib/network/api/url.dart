class ApiUrl {

  final Map<String, String> requestParams;
  final String route;

  static String host = "https://api.ikleeralles.nl";

  ApiUrl (this.route, { this.requestParams });

  @override
  String toString() {
    return "$host/$route";
  }
}
