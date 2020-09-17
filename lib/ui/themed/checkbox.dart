import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';

class ThemedCheckBox extends StatelessWidget {

  final double size;
  final bool isSelected;
  final Function(bool) onChange;

  ThemedCheckBox ({ this.size = 25, @required this.isSelected, @required this.onChange });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(2),
                child: Container(decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? BrandColors.checkboxSelectedColor: Colors.transparent
                )),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isSelected ? BrandColors.checkboxSelectedColor : BrandColors.checkboxColor,
                        width: 3
                    )
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        this.onChange(!isSelected);
      },
    );
  }

}