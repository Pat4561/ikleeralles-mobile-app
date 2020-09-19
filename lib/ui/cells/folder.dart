import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/folder.dart';

class FolderCell extends StatelessWidget {

  final Folder folder;
  final Function(Folder) onPressed;
  final Function(Folder) onDeletePressed;

  FolderCell (this.folder, {  @required this.onPressed, @required this.onDeletePressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: Material(
          child: InkWell(
            child: ListTile(

              title: Text(
                  folder.name,
                  style: TextStyle(
                      fontFamily: Fonts.ubuntu,
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                  )
              ),
              trailing: Icon(Icons.chevron_right)
            ),
            onTap: () {
              onPressed(folder);
            },
          ),
          color: Colors.white,
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: FlutterI18n.translate(context, TranslationKeys.delete),
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              onDeletePressed(folder);
            },
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