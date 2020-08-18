import 'package:http/http.dart';
import 'package:ikleeralles/network/api/request.dart';
import 'package:ikleeralles/network/api/url.dart';
import 'package:ikleeralles/network/models/login_result.dart';
import 'package:ikleeralles/network/parsing_operation.dart';

enum RequestMethod {
  get,
  post
}

class RequestHelper {

  ApiRequest apiRequest({ String route }) {
    return ApiRequest(
      ApiUrl(
        route
      )
    );
  }

  Future<Response> executeRequest({ String route,  RequestMethod method = RequestMethod.get, Map<String, dynamic> body }) async {
    var request = apiRequest(
      route: route
    );
    Response response;
    if (method == RequestMethod.get) {
      response = await request.get();
    } else if (method == RequestMethod.post) {
      response = await request.post(body: body);
    }
    return response;
  }

  Future<T> singleObjectRequest<T>({ String route, T Function(Map) toObject, RequestMethod method = RequestMethod.get, Map<String, dynamic> body}) async {

    var response = await executeRequest(
        route: route,
        method: method,
        body: body
    );

    return ParsingOperation<T>(response, toObject: (Map map) {
      return toObject(map);
    }).singleObject();
  }

  Future<List<T>> multiObjectsRequest<T>({ String route, T Function(Map) toObject, RequestMethod method = RequestMethod.get, Map<String, dynamic> body}) async {
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

class SecuredRequestHelper extends RequestHelper {

  final LoginResult loginResult;

  SecuredRequestHelper (this.loginResult);

  @override
  ApiRequest apiRequest({String route}) {
    return SecuredApiRequest(
        ApiUrl(
            route
        ),
        loginResult: this.loginResult
    );
  }

}