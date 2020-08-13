import 'package:http/http.dart';
import 'package:ikleeralles/network/api/request.dart';
import 'package:ikleeralles/network/api/url.dart';
import 'package:ikleeralles/network/parsing_operation.dart';

enum RequestMethod {
  get,
  post
}

class RequestHelper {

  static Future<Response> executeRequest({ String route,  RequestMethod method = RequestMethod.get, Map body }) async {
    var request = ApiRequest(
        ApiUrl(
            route
        )
    );
    Response response;
    if (method == RequestMethod.get) {
      response = await request.get();
    } else if (method == RequestMethod.post) {
      response = await request.post(body: body);
    }
    return response;
  }

  static Future<T> singleObjectRequest<T>({ String route, T Function(Map) toObject, RequestMethod method = RequestMethod.get, Map body}) async {

    var response = await executeRequest(
        route: route,
        method: method,
        body: body
    );

    return ParsingOperation<T>(response, toObject: (Map map) {
      return toObject(map);
    }).singleObject();
  }

  static Future<List<T>> multiObjectsRequest<T>({ String route, T Function(Map) toObject, RequestMethod method = RequestMethod.get, Map body}) async {
    var response = await executeRequest(
        route: route,
        method: method,
        body: body
    );

    return ParsingOperation<T>(response, toObject: (Map map) {
      return toObject(map);
    }).asList();
  }


}