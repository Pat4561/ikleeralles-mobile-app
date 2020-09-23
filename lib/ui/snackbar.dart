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
      fontSize: fontSize
  );


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
        color: Colors.white,
        borderRadius: BorderRadius.circular(25)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20
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