import 'package:ikleeralles/network/keys.dart';

enum WebResponseEventType {
  registeredAccount,
  forgotPassword
}

class WebResponse {

  WebResponseEventType eventType;
  Map meta;

  WebResponse (Map map) {
    this.eventType = WebResponseEventType.values[map[ObjectKeys.eventType]];
    this.meta = map[ObjectKeys.meta];
  }

}