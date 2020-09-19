import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/ui/bottomsheets/presenter.dart';
import 'package:ikleeralles/ui/tables/trash.dart';

class TrashBottomSheetPresenter extends BottomSheetPresenter {

  final Function onRecoverPressed;
  final GlobalKey<TrashTableState> key;
  final OperationManager operationManager;

  TrashBottomSheetPresenter ({ @required this.operationManager, @required this.onRecoverPressed, this.key });

  @override
  Widget body(BuildContext context) {
    return TrashTable(
      operationManager: operationManager,
      key: key,
      onRecoverPressed: onRecoverPressed,
    );
  }

  @override
  Widget header(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20
      ),
      child: Text(
        FlutterI18n.translate(context, TranslationKeys.trashCan),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.ubuntu,
        ),
        textAlign: TextAlign.start,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: Colors.white
              )
          )
      ),
    );
  }

}