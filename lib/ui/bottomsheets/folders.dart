import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/network/models/folder.dart';
import 'package:ikleeralles/ui/bottomsheets/presenter.dart';
import 'package:ikleeralles/ui/tables/folders.dart';
import 'package:ikleeralles/ui/themed/button.dart';

class FoldersBottomSheetPresenter extends BottomSheetPresenter {

  final OperationManager operationManager;
  final Function(Folder) onDeleteFolderPressed;
  final Function(Folder) onFolderPressed;
  final Function() createFolderPressed;
  final GlobalKey<FoldersTableState> key;

  FoldersBottomSheetPresenter ({ @required this.onDeleteFolderPressed, @required this.operationManager, @required this.onFolderPressed, @required this.createFolderPressed, this.key });

  @override
  Widget body(BuildContext context) {
    return FoldersTable(
        operationManager: this.operationManager,
        onDeleteFolderPressed: onDeleteFolderPressed,
        onFolderPressed: onFolderPressed,
        key: key
    );
  }

  @override
  Widget header(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(
            FlutterI18n.translate(context, TranslationKeys.myFolders),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: Fonts.ubuntu,
            ),
            textAlign: TextAlign.start,
          )),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 10
            ),
            child: ThemedButton(
              FlutterI18n.translate(context, TranslationKeys.newFolder),
              icon: Icons.add,
              iconSize: 18,
              buttonColor: BrandColors.secondaryButtonColor,
              fontSize: 13,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10
              ),
              borderRadius: BorderRadius.circular(15),
              onPressed: createFolderPressed,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: BrandColors.borderColor
              )
          )
      ),
    );
  }

}