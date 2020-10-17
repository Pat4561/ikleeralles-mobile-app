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
    return BottomSheetHeader(
      title: FlutterI18n.translate(context, TranslationKeys.trashCan),
      borderColor: Colors.white,
    );
  }

}