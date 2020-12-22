import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/ui/background_builder.dart';
import 'package:ikleeralles/ui/navigation_drawer.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class PremiumInfoCard extends StatelessWidget {

  final String assetPath;

  final String title;

  final String subTitle;

  final String pricingTitle;

  final Function() onPressed;

  PremiumInfoCard ({ this.assetPath, this.title, this.subTitle, this.pricingTitle, this.onPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: SvgPicture.asset(this.assetPath),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(this.title, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: Fonts.ubuntu,
                          )),
                          SizedBox(height: 4),
                          Text(this.subTitle, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: Fonts.ubuntu,
                            color: BrandColors.textColorLighter
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: BrandColors.borderColor
                    )
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text(this.pricingTitle, style: TextStyle(
                          fontFamily: Fonts.ubuntu,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ), textAlign: TextAlign.center),
                      margin: EdgeInsets.symmetric(
                        vertical: 10
                      ),
                    ),
                    ThemedButton(
                      "Kiezen",
                      buttonColor: Colors.green,
                      onPressed: () => () {

                      },
                      borderRadius: BorderRadius.circular(12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}



enum IAPManagerStatus {

  idle,
  ready,
  failed,
  loading

}

class IAPManagerState<T> {

  final IAPManagerStatus status;

  final T result;

  final Exception error;

  IAPManagerState ({ @required this.status, this.result, this.error });

}


class IAPManager extends Model {


  IAPManagerState<Offerings> _state = IAPManagerState<Offerings>(status: IAPManagerStatus.idle);

  IAPManagerState<Offerings> get state => _state;

  void load() {
    _state = IAPManagerState<Offerings>(status: IAPManagerStatus.loading);
    Purchases.getOfferings().then((value) {
      _state = IAPManagerState<Offerings>(status: IAPManagerStatus.ready, result: value);
      notifyListeners();
    }).catchError((e) {
      _state = IAPManagerState<Offerings>(status: IAPManagerStatus.failed, error: e);
      notifyListeners();
    });
  }


}

class PriceUtil {

  static double formatPrice(double price) {
    return (price * 100).floorToDouble() / 100;
  }



}


class EntitlementsManager {


  Future _oadFromServer() async {
    await AuthService().securedApi.getPremiumInfo();
  }


}


class PremiumInfoSubPage extends NavigationDrawerContentChild {

  final IAPManager _iapManager = IAPManager();

  PremiumInfoSubPage (NavigationDrawerController controller, String key) : super(controller, key: key) {
    _iapManager.load();
    EntitlementsManager()._oadFromServer();
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      color: BrandColors.lightGreyBackgroundColor.withOpacity(0.4),
      child: ScopedModel<IAPManager>(
        model: _iapManager,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget widget, IAPManager manager) {

            IAPManagerStatus status = _iapManager.state.status;

            if (status == IAPManagerStatus.loading) {
              return BackgroundBuilder.defaults.loadingDetailed(context);
            } else if (status == IAPManagerStatus.ready) {
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ThemedButton(
                          "Eerdere aankopen herstellen",
                          buttonColor: Colors.transparent,
                          borderSide: BorderSide(
                            color: BrandColors.textColorLighter
                          ),
                          labelColor: BrandColors.textColorLighter,
                          onPressed: () => () {

                          },
                          borderRadius: BorderRadius.circular(12),
                        )
                      ],
                    ),
                  )
                ],
              );
            } else if (status == IAPManagerStatus.failed) {
              return BackgroundBuilder.defaults.error(context);
            } else {
              return Container();
            }

          }
        ),
      ),
    );
  }

  @override
  String title(BuildContext context) {
    return FlutterI18n.translate(context, TranslationKeys.premium);
  }

}

