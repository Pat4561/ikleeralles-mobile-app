import 'package:flutter/material.dart';
import 'package:ikleeralles/logic/managers/extensions.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/package.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

enum IAPManagerStatus {

  idle,
  ready,
  failed,
  loading

}

class IAPSku {

  static const String yearlySubIOS = "yearly_sub_premium_pro";
  static const String monthlySubIOS = "monthly_sub_premium_plus";
  static const String yearlySubAndroid = "ikl_sub_premium_pro";
  static const String monthlySubAndroid = "ikl_sub_premium_plus";

}

class SyncedOfferingsResult {

  final Offerings offerings;

  WebPackageType _webPackageType; //Verify the user package

  WebPackageType get webPackageType => _webPackageType;

  PurchaserInfo _purchaserInfo;

  PurchaserInfo get purchaserInfo => _purchaserInfo;

  SyncedOfferingsResult ({ @required this.offerings, WebPackageType webPackageType, PurchaserInfo purchaserInfo }) {
    _purchaserInfo = purchaserInfo;
    _webPackageType = webPackageType;
  }

  void updateInfo(PurchaserInfo purchaserInfo, WebPackageType webPackageType) {
    _purchaserInfo = purchaserInfo;
    _webPackageType = webPackageType;
  }

  bool get hasPro {
    return _purchaserInfo.activeSubscriptions.contains(IAPSku.yearlySubIOS) || _purchaserInfo.activeSubscriptions.contains(IAPSku.yearlySubAndroid) || _webPackageType == WebPackageType.pro;
  }

  bool get hasPlus {
    return _purchaserInfo.activeSubscriptions.contains(IAPSku.monthlySubIOS) || _purchaserInfo.activeSubscriptions.contains(IAPSku.monthlySubAndroid) || _webPackageType == WebPackageType.plus;
  }

  bool get hasAny {
    return hasPlus || hasPro;
  }

}

class IAPManagerState {

  final IAPManagerStatus status;

  final SyncedOfferingsResult result;

  final Exception error;

  IAPManagerState ({ @required this.status, this.result, this.error });

}



class IAPManager extends Model {

  IAPManagerState _state = IAPManagerState(status: IAPManagerStatus.idle);


  IAPManagerState get state => _state;

  void load() {
    _state = IAPManagerState(status: IAPManagerStatus.loading);

    Future.wait([Purchases.getOfferings(),
      AuthService().securedApi.getWebPackageType(), Purchases.getPurchaserInfo()]).then((value) {
      _state = IAPManagerState(status: IAPManagerStatus.ready, result: SyncedOfferingsResult(offerings: value[0], webPackageType: value[1], purchaserInfo: value[2]));
      notifyListeners();
    }).catchError((e) {
      _state = IAPManagerState(status: IAPManagerStatus.failed, error: e);
      notifyListeners();
    });
  }


  void _sendAsyncToServer(PurchaserInfo purchaserInfo) {
    try {
      AuthService().sendPurchaseInfoToServer(purchaserInfo);
    } catch (e) {
      print("Could not send purchase to server");
      print(e);
    }
  }

  Future purchasePackage(Package package) {
    return Purchases.purchasePackage(package).then((purchaserInfo) {

      state.result.updateInfo(purchaserInfo, state.result.webPackageType);
      _sendAsyncToServer(purchaserInfo);

      notifyListeners();

    });
  }

  Future restore() {
    Future future = Future.wait([
      AuthService().securedApi.getWebPackageType(),
      Purchases.restoreTransactions()
    ]).then((value) {

      WebPackageType webPackageType = value[0];
      PurchaserInfo purchaserInfo = value[1];

      state.result.updateInfo(purchaserInfo, webPackageType);
      _sendAsyncToServer(purchaserInfo);

      notifyListeners();
    });
    return future;
  }

}


class PriceUtil {

  static double formatPrice(double price) {
    return (price * 100).floorToDouble() / 100;
  }

}
