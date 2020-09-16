import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/cells/inner.dart';

abstract class ActionCell extends StatelessWidget {

  final Function onPressed;
  final double iconSize;

  ActionCell ({ this.onPressed, this.iconSize = 25 });

  Widget badge(BuildContext context, { @required int count  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: BrandColors.badgeBackgroundColor
      ),
      padding: EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 15
      ),
      child: Text(
        FlutterI18n.translate(context, TranslationKeys.itemsBadge, { "count": count.toString() }),
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: BrandColors.badgeTextColor
        ),
      ),
    );
  }

  Widget create({ String iconAssetPath, String title, String subTitle, Widget trailing }) {
    return Material(child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: DottedBorder(
          strokeWidth: 1.5,
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          color: BrandColors.borderColor,
          dashPattern: [6, 4],
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: InnerCell(
              leading: Container(
                width: iconSize,
                height: iconSize,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        iconAssetPath,
                        width: iconSize,
                        height: iconSize,
                      ),
                    )
                  ],
                ),
              ),
              title: title,
              subTitle: subTitle,
              trailing: trailing,
            ),
          )
      ),
      onTap: onPressed,
    ), color: Colors.white);
  }


}

class PublicListsActionCell extends ActionCell {

  PublicListsActionCell ({ Function onPressed }) : super(onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return create(
        iconAssetPath: AssetPaths.internet,
        title: FlutterI18n.translate(context, TranslationKeys.publicLists),
        subTitle: FlutterI18n.translate(context, TranslationKeys.publicListsDescription)
    );
  }

}

class MyFoldersActionCell extends ActionCell {

  final int count;

  MyFoldersActionCell ({ Function onPressed, this.count }) : super(onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return create(
        iconAssetPath: AssetPaths.rootDirectory,
        title: FlutterI18n.translate(context, TranslationKeys.myFolders),
        trailing: badge(context, count: count)
    );
  }

}

class TrashActionCell extends ActionCell {

  final int count;

  TrashActionCell ({ Function onPressed, this.count }) : super(onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return create(
        iconAssetPath: AssetPaths.trash,
        title: FlutterI18n.translate(context, TranslationKeys.trashCan),
        trailing: badge(context, count: count)
    );
  }

}