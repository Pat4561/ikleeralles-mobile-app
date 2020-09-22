import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';

class BackgroundBuilder {

  static const Color defaultBackgroundColor = Color.fromRGBO(240, 240, 240, 1);

  static BackgroundDefaults defaults = BackgroundDefaults();

  static Widget build({ Color backgroundColor = BackgroundBuilder.defaultBackgroundColor, Widget widget, Alignment alignment = Alignment.center }) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: alignment,
              child: Container(
                child: widget,
                constraints: BoxConstraints(
                    maxWidth: 300
                ),
              )
          )
        ],
      ),
    );
  }

  static Widget buildWithColumn({ Color backgroundColor = BackgroundBuilder.defaultBackgroundColor, Alignment alignment = Alignment.center, @required List<Widget> children }) {
    return build(
        backgroundColor: backgroundColor,
        alignment: alignment,
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        )
    );
  }

  static Widget buildWithTitles({ String title, String subTitle, Color backgroundColor = BackgroundBuilder.defaultBackgroundColor, Alignment alignment = Alignment.center }) {
    return buildWithColumn(
        backgroundColor: backgroundColor,
        alignment: alignment,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 18  ,
                  fontFamily: Fonts.montserrat,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: Fonts.ubuntu
              ),
            ),
          ),
        ]
    );
  }

}


class BackgroundDefaults {

  Widget noResults(BuildContext context, { Alignment alignment = Alignment.center }) {
    return BackgroundBuilder.buildWithTitles(
        title: FlutterI18n.translate(context, TranslationKeys.noResults),
        subTitle: FlutterI18n.translate(context, TranslationKeys.noResultsSubTitle),
        alignment: alignment
    );
  }

  Widget error(BuildContext context, { Alignment alignment = Alignment.center }) {
    return BackgroundBuilder.buildWithTitles(
        title: FlutterI18n.translate(context, TranslationKeys.error),
        subTitle: FlutterI18n.translate(context, TranslationKeys.errorSubTitle),
        alignment: alignment
    );
  }

  Widget loadingSimple(BuildContext context) {
    return BackgroundBuilder.build(
        widget: Container(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(BrandColors.secondaryButtonColor),
            strokeWidth: 3,
          ),
        )
    );
  }

  Widget loadingDetailed(BuildContext context) {
    return BackgroundBuilder.buildWithColumn(
        children: [
          Container(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(BrandColors.secondaryButtonColor),
              strokeWidth: 3,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              FlutterI18n.translate(context, TranslationKeys.busyLoading),
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: Fonts.montserrat
              ),
            ),
          ),
        ]
    );
  }

}