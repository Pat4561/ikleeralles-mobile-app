import 'package:http/http.dart' as http;
import 'dart:convert';

class ParsingOperation<T> {

  final http.Response response;
  final T Function(Map map) toObject;

  ParsingOperation (this.response, { this.toObject });

  List<T> asList() {
    String body = response.body;
    List<T> items = [];
    if (body != null) {
      var jsonObj = json.decode(body);
      if (jsonObj != null) {
        if (jsonObj is List) {
          items = jsonObj.map((e) => this.toObject(e)).toList();
        } else if (jsonObj is Map) {
          T item = this.toObject(jsonObj);
          items.add(item);
        }
      }
    }

    return items;
  }

  T singleObject() {
    List<T> items = asList();
    if (items.length > 0) {
      return items.first;
    }
    return null;
  }

}
