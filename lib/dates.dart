import 'package:intl/intl.dart';

class Dates {

  static String format(DateTime dateTime) {
    try {
      return DateFormat("dd MMMM yyyy").format(dateTime);
    } catch (e) {
      return "";
    }
  }

}