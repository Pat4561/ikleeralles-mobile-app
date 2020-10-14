import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ikleeralles/constants.dart';


ScaffoldFeatureController showSnackBar({
  GlobalKey<ScaffoldState> scaffoldKey,
  BuildContext buildContext,
  @required String message,
  @required bool isError,
}) {

  if (scaffoldKey != null) {
    return scaffoldKey.currentState.showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  if (buildContext != null) {
    Scaffold.of(buildContext).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: isError ? Colors.red : Colors.green)
    );
  }

  throw Exception("Either a buildContext or scaffoldkey is required");

}


void showToast(String message, { Color backgroundColor = Colors.red, Color textColor = Colors.white, double fontSize = 16 }) {

  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
  );


}

class LoadingMessageHandler {

  FToast _toast;

  void show(BuildContext context) {
    _toast = showLoadingToast(context);
  }

  void _delay(Function callback) {
    Future.delayed(Duration(milliseconds: 150), callback);
  }

  void clear({ Function callback }) {
    if (_toast != null) {
      _toast.removeCustomToast();
    }
    if (callback != null) {
      _delay(callback);
    }
  }

}

FToast showLoadingToast(BuildContext context, { Duration timeOutDuration }) {

  FToast fToast = FToast();
  fToast.init(context);

  if (timeOutDuration == null)
    timeOutDuration = Duration(seconds: 5);

  fToast.showToast(
    gravity: ToastGravity.TOP,
    toastDuration: timeOutDuration,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: BrandColors.secondaryButtonColor,
          width: 1.5
        )
      ),
      margin: EdgeInsets.symmetric(
        vertical: 10
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              FlutterI18n.translate(context, TranslationKeys.busyProcessing),
              style: TextStyle(
                fontSize: 14,
                fontFamily: Fonts.ubuntu,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                BrandColors.secondaryButtonColor
              ),
            ),
          )
        ],
      ),
    )
  );

  return fToast;
}