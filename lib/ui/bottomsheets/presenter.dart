import 'package:flutter/material.dart';

abstract class BottomSheetPresenter {

  Widget header(BuildContext context);

  Widget body(BuildContext context);

  void show(BuildContext context) {
    showModalBottomSheet(
        builder: (BuildContext context) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                header(context),
                Expanded(
                  child: body(context),
                )
              ],
            ),
          );
        },
        context: context
    );
  }

}