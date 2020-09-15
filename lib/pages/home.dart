import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/appbar.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class InnerCell extends StatelessWidget {

  final Widget leading;
  final Widget trailing;
  final String title;
  final String subTitle;

  InnerCell ({ @required this.leading, this.trailing, @required this.title, this.subTitle });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: this.leading,
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Text(
                      this.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: Fonts.montserrat,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  Visibility(
                    child: Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        this.subTitle ?? "",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Fonts.montserrat,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    visible: this.subTitle != null,
                  )
                ],
              ),
            ),
          ),
          Visibility(child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: this.trailing ?? Container(),
          ), visible: this.trailing != null)
        ],
      ),
    );
  }

}

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

class ThemedCheckBox extends StatelessWidget {

  final double size;
  final bool isSelected;
  final Function(bool) onChange;

  ThemedCheckBox ({ this.size = 25, @required this.isSelected, @required this.onChange });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(2),
                child: Container(decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? BrandColors.checkboxSelectedColor: BrandColors.checkboxColor
                )),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isSelected ? BrandColors.checkboxSelectedColor : BrandColors.checkboxColor,
                        width: 3
                    )
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        this.onChange(!isSelected);
      },
    );
  }

}

class ExerciseListCell extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Material(child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: Container(
        child: InnerCell(
          leading: ThemedCheckBox(
            size: 25,
            isSelected: true,
            onChange: (newValue) {

            }
          ),
          title: "BS4",
          subTitle: "Spanish - English",
          trailing: Container(),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(
            color: BrandColors.borderColor,
            width: 1
          )
        ),
      ),
      onTap: () {

      },
    ), color: Colors.white);
  }

}

class HomePageState extends State<HomePage> {

  void _onTrashPressed() {

  }

  void _onMyFoldersPressed() {

  }

  void _onPublicListsPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: FlutterI18n.translate(context, TranslationKeys.myLists),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(
              15
          ),
          children: <Widget>[
            TrashActionCell(
              count: 11,
              onPressed: _onTrashPressed,
            ),
            MyFoldersActionCell(
              count: 20,
              onPressed: _onMyFoldersPressed,
            ),
            PublicListsActionCell(
              onPressed: _onPublicListsPressed,
            ),
            ExerciseListCell()
          ],
        ),
        color: Colors.white,
      ),

    );
  }

}