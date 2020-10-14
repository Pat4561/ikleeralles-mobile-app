import 'package:intl/intl.dart';
import 'package:ikleeralles/network/keys.dart';


abstract class ParsableObject {

  Map<String, dynamic> toMap();

  ParsableObject (Map<String, dynamic> dictionary) {
    parse(dictionary);
  }

  ParsableObject.create();

  void parse(Map<String, dynamic> dictionary);

}

abstract class ObjectBase extends ParsableObject {

  int id;
  bool deleted;

  final DateFormat parsingDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  ObjectBase (Map<String, dynamic> dictionary) : super(dictionary);

  ObjectBase.create ({ this.id }) : super.create();

  @override
  void parse(Map<String, dynamic> dictionary) {
    id = dictionary[ObjectKeys.id];
    deleted = dictionary[ObjectKeys.deleted];
  }

  DateTime parseDate(String dateStr) {
    if (dateStr == null)
      return null;
    return parsingDateFormat.parse(dateStr);
  }

  String toDateStr(DateTime date) {
    if (date == null)
      return null;
    return parsingDateFormat.format(date);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ObjectKeys.id: id,
      ObjectKeys.deleted: deleted
    };
  }


}