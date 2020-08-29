import 'package:flutter/material.dart';


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
