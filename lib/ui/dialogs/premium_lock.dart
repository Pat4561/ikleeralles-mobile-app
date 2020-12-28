import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/pages/home/main.dart';
import 'package:ikleeralles/pages/home/premium.dart';
import 'package:ikleeralles/ui/themed/button.dart';


class PremiumLocker {

  bool _isPresentationScheduled = false;

  bool get isPremium {
    return false;
  }

  void schedulePresentation(BuildContext context, { Function undoAction }) {

    if (!_isPresentationScheduled) {
      _isPresentationScheduled = true;
      Future.delayed(Duration(milliseconds: 200), () {
        PremiumLockDialog.show(context);
        if (undoAction != null) {
          undoAction();
        }
        _isPresentationScheduled = false;
      });
    }

  }

}

class PremiumLockDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  FlutterI18n.translate(context, TranslationKeys.premiumLockTitle), //"Premium optie"
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.ubuntu
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: BrandColors.borderColor,
                            width: 1
                        )
                    ),
                    color: BrandColors.lightGreyBackgroundColor
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),

                child: Row(
                  children: [
                    Container(
                        child: Icon(Icons.warning, color: BrandColors.secondaryButtonColor, size: 40)
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        child: Text(FlutterI18n.translate(context, TranslationKeys.premiumLockDesc), style: TextStyle(
                            fontFamily: Fonts.ubuntu,
                            fontSize: 15
                        )), //""
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: BrandColors.borderColor,
                            width: 1
                        )
                    ),
                    color: BrandColors.lightGreyBackgroundColor
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20
                ),
                child: Row(
                  children: [
                    ThemedButton(
                      FlutterI18n.translate(context, TranslationKeys.premiumLockViewAction), //bekijken
                      buttonColor: BrandColors.secondaryButtonColor,
                      onPressed: () {

                        PremiumInfoPage.show(context);


                      },
                      borderRadius: BorderRadius.circular(12),
                    ),
                    Spacer(),
                    FlatButton(
                      child: Text(FlutterI18n.translate(context, TranslationKeys.cancel), style: TextStyle(
                          fontFamily: Fonts.ubuntu,
                          fontSize: 15
                      )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  static void show(BuildContext context, { Function(String) onCreatePressed }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PremiumLockDialog();
        }
    );
  }

}
