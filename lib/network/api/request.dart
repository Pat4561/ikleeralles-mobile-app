import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ikleeralles/network/api/url.dart';
import 'package:ikleeralles/network/auth/userinfo.dart';

class ApiRequest {

  final ApiUrl url;

  Map<String, String> headers;

  ApiRequest (this.url, { this.headers });

  Future<http.Response> post({ Map<String, dynamic> body }) {
    return http.post(url.toString(), body: json.encode(body), headers: headers);
  }

  Future<http.Response> get() {
    return http.get(url.toString(), headers: headers);
  }

}

class SecuredApiRequest extends ApiRequest {

  SecuredApiRequest (ApiUrl url, { @required AccessToken accessToken,  Map<String, String> additionalHeaders }) : super(url, headers: additionalHeaders) {
    if (this.headers == null)
      this.headers = {};
    this.headers["Authorization"] = "Bearer ${accessToken.token}";
  }

}