import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/themed/appbar.dart';
import 'package:ikleeralles/ui/themed/button.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class MultiSelectionButton extends StatelessWidget {

  final bool allSelected;
  final Function(bool) onChange;

  MultiSelectionButton ({ @required this.allSelected, @required this.onChange });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ThemedButton(
        FlutterI18n.translate(context, allSelected ? TranslationKeys.unSelectAll : TranslationKeys.selectAll),
        contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 15
        ),
        fontSize: 13,
        buttonColor: BrandColors.themeColor,
        filled: allSelected,
        borderRadius: BorderRadius.circular(10),
        onPressed: () {
          onChange(!allSelected);
        },
      ),
    );
  }

}

class SelectionBar extends StatelessWidget {

  final int selectionCount;
  final Function onStartPressed;
  final Function onMergePressed;
  final Function onDeletePressed;

  SelectionBar ({ @required this.selectionCount, @required this.onStartPressed,
    @required this.onMergePressed, @required this.onDeletePressed });

  Widget iconButton({ @required Function onPressed, @required String assetPath }) {
    return Container(
        margin: EdgeInsets.only(
            left: 15
        ),
        child: IconButton(
          icon: SvgPicture.asset(
            assetPath,
            color: Colors.white,
          ),
          onPressed: onPressed,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: BrandColors.themeColor,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: Container(
              child: AutoSizeText(
                FlutterI18n.translate(context, TranslationKeys.selectedLists, { "count": selectionCount.toString() }),
                minFontSize: 11,
                style: TextStyle(
                    fontFamily: Fonts.ubuntu,
                    fontSize: 14,
                    color: Colors.white
                ),
              ),
            )),
            iconButton(
              assetPath: AssetPaths.start,
              onPressed: this.onStartPressed
            ),
            iconButton(
              assetPath: AssetPaths.merge,
              onPressed: this.onMergePressed
            ),
            iconButton(
              assetPath: AssetPaths.trashSolid,
              onPressed: this.onDeletePressed
            )
          ],
        ),
      ),
    );
  }

}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: FlutterI18n.translate(context, TranslationKeys.myLists),
      ),
      body: Container(
        color: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: SvgPicture.asset(
          AssetPaths.add
        ),
      ),
    );
  }

}