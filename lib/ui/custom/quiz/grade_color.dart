import 'package:flutter/material.dart';
class GradeColor {

  final double grade;

  Color _value;
  Color get value => _value;

  GradeColor (this.grade) {
    if (this.grade > 7) {
      _value = Colors.green;
    } else if (this.grade > 5.5) {
      _value = Colors.orange;
    } else {
      _value = Colors.red;
    }
  }

}