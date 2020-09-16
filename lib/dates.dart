import 'package:intl/intl.dart';

class Dates {

  static String format(DateTime dateTime) {
    return DateFormat("dd MMMM yyyy").format(dateTime);
  }

}