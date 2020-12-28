import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:ikleeralles/network/auth/service.dart';

class SetInputTypeProvider {

  final PlatformDataProvider provider;

  SetInputTypeProvider (this.provider);

  String defaultValue() {
    return provider.languageData.get("nl");
  }

  String defaultKey() {
    return "nl";
  }

  List<String> allValues() {
    return provider.languageData.allValues();
  }

  List<String> allKeys() {
    return provider.languageData.allKeys();
  }

}


class PlatformDataConstants {

  static List<String> years = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Anders"];
  static List<String> levels = ["basisschool","vwo","havo","vmbo-t","vmbo-gt","vmbo-k","vmbo-b","a","a2/b1","lwoo/vmbo-b","lwoo/vmbo-bk",
    "vmbo-b/lwoo","vmbo-gt/havo","vmbo-kgt/havo","vmbo-t/havo","havo/vwo","mbo","universiteit","vavo","cursus"];
  static List<Map> languages = [
    {"code":"af","name":"Afrikaans"},
    {"code":"sq","name":"Albanees"},
    {"code":"am","name":"Amharisch"},
    {"code":"ar","name":"Arabisch"},
    {"code":"hy","name":"Armeens"},
    {"code":"az","name":"Azerbeidzjaans"},
    {"code":"eu","name":"Baskisch"},
    {"code":"bn","name":"Bengaals"},
    {"code":"my","name":"Birmaans"},
    {"code":"bs","name":"Bosnisch"},
    {"code":"bg","name":"Bulgaars"},
    {"code":"ca","name":"Catalaans"},
    {"code":"ceb","name":"Cebuano"},
    {"code":"ny","name":"Chichewa"},
    {"code":"zh-TW","name":"Chinees (traditioneel)"},
    {"code":"zh-CN","name":"Chinees (vereenvoudigd)"},
    {"code":"co","name":"Corsicaans"},
    {"code":"da","name":"Deens"},
    {"code":"de","name":"Duits"},
    {"code":"en","name":"Engels"},
    {"code":"eo","name":"Esperanto"},
    {"code":"et","name":"Ests"},
    {"code":"fi","name":"Fins"},
    {"code":"fr","name":"Frans"},
    {"code":"fy","name":"Fries"},
    {"code":"gl","name":"Galicisch"},
    {"code":"ka","name":"Georgisch"},
    {"code":"el","name":"Grieks"},
    {"code":"gu","name":"Gujarati"},
    {"code":"ht","name":"Haïtiaans Creools"},
    {"code":"ha","name":"Hausa"},
    {"code":"haw","name":"Hawaïaans"},
    {"code":"iw","name":"Hebreeuws"},
    {"code":"hi","name":"Hindi"},
    {"code":"hmn","name":"Hmong"},
    {"code":"hu","name":"Hongaars"},
    {"code":"ga","name":"Iers"},
    {"code":"ig","name":"Igbo"},
    {"code":"is","name":"IJslands"},
    {"code":"id","name":"Indonesisch"},
    {"code":"it","name":"Italiaans"},
    {"code":"ja","name":"Japans"},
    {"code":"jw","name":"Javaans"},
    {"code":"yi","name":"Jiddisch"},
    {"code":"kn","name":"Kannada"},
    {"code":"kk","name":"Kazachs"},
    {"code":"km","name":"Khmer"},
    {"code":"rw","name":"Kinyarwanda"},
    {"code":"ky","name":"Kirgizisch"},
    {"code":"ku","name":"Koerdisch"},
    {"code":"ko","name":"Koreaans"},
    {"code":"hr","name":"Kroatisch"},
    {"code":"lo","name":"Lao"},
    {"code":"la","name":"Latijn"},
    {"code":"lv","name":"Lets"},
    {"code":"lt","name":"Litouws"},
    {"code":"lb","name":"Luxemburgs"},
    {"code":"mk","name":"Macedonisch"},
    {"code":"mg","name":"Malagasi"},
    {"code":"ml","name":"Malayalam"},
    {"code":"ms","name":"Maleis"},
    {"code":"mt","name":"Maltees"},
    {"code":"mi","name":"Maori"},
    {"code":"mr","name":"Marathi"},
    {"code":"mn","name":"Mongools"},
    {"code":"nl","name":"Nederlands"},
    {"code":"ne","name":"Nepalees"},
    {"code":"no","name":"Noors"},
    {"code":"or","name":"Odia (Oriya)"},
    {"code":"ug","name":"Oeigoers"},
    {"code":"uk","name":"Oekraïens"},
    {"code":"uz","name":"Oezbeeks"},
    {"code":"ps","name":"Pashto"},
    {"code":"fa","name":"Perzisch"},
    {"code":"pl","name":"Pools"},
    {"code":"pt","name":"Portugees"},
    {"code":"pa","name":"Punjabi"},
    {"code":"ro","name":"Roemeens"},
    {"code":"ru","name":"Russisch"},
    {"code":"sm","name":"Samoaans"},
    {"code":"gd","name":"Schots Keltisch"},
    {"code":"sr","name":"Servisch"},
    {"code":"st","name":"Sesotho"},
    {"code":"sn","name":"Shona"},
    {"code":"sd","name":"Sindhi"},
    {"code":"si","name":"Sinhala"},
    {"code":"sk","name":"Slovaaks"},
    {"code":"sl","name":"Sloveens"},
    {"code":"su","name":"Soendanees"},
    {"code":"so","name":"Somalisch"},
    {"code":"es","name":"Spaans"},
    {"code":"sw","name":"Swahili"},
    {"code":"tg","name":"Tadzjieks"},
    {"code":"tl","name":"Tagalog"},
    {"code":"ta","name":"Tamil"},
    {"code":"tt","name":"Tataars"},
    {"code":"te","name":"Telugu"},
    {"code":"th","name":"Thai"},
    {"code":"cs","name":"Tsjechisch"},
    {"code":"tk","name":"Turkmeens"},
    {"code":"tr","name":"Turks"},
    {"code":"ur","name":"Urdu"},
    {"code":"vi","name":"Vietnamees"},
    {"code":"cy","name":"Wels"},
    {"code":"be","name":"Wit-Russisch"},
    {"code":"xh","name":"Xhosa"},
    {"code":"yo","name":"Yoruba"},
    {"code":"zu","name":"Zoeloe"},
    {"code":"sv","name":"Zweeds"},
    {"code":"he","name":"Hebreeuws"},
    {"code":"zh","name":"Chinees (vereenvoudigd)"}
  ];

}

class LanguageData {

  Map<String, String> _data;

  LanguageData () {
    _data = LanguageData.parse(PlatformDataConstants.languages);
  }

  static Map<String, String> parse(List<Map> jsonMapList) {
    Map<String, String> languagesMap = Map<String, String>();
    for (var jsonMap in jsonMapList) {
      languagesMap[jsonMap["code"]] = jsonMap["name"];
    }
    return languagesMap;
  }

  void updateData(Map<String, String> data) {
    _data = data;
  }

  String get(String key) {
    return _data.containsKey(key) ? _data[key] : key;
  }

  List<String> allValues() {
    return _data.values.toList();
  }


  List<String> allKeys() {
    return _data.keys.toList();
  }

}

class PlatformDataProvider extends Model {

  List<String> years = PlatformDataConstants.years;
  List<String> levels = PlatformDataConstants.levels;

  final LanguageData languageData = LanguageData();

  Completer _completer;

  Future load() {
    if (_completer != null && !_completer.isCompleted) {
      return _completer.future;
    }

    _completer = Completer();

    Future.wait([AuthService().securedApi.getLevels(), AuthService().securedApi.getLanguages()]).then((values) {
      this.levels = values[0];
      this.languageData.updateData(values[1]);
      _completer.complete();
    }).catchError((e) {
      _completer.completeError(e);
    }).whenComplete(() {
      notifyListeners();
    });

    return _completer.future;
  }

}