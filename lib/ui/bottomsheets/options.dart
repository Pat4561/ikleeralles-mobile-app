import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/ui/bottomsheets/presenter.dart';

class OptionsBottomSheetPresenter<T> extends BottomSheetPresenter {

  final String title;
  final List<T> items;
  final T selectedItem;
  final Function(T) onPressed;
  final String Function(T) toLabel;

  OptionsBottomSheetPresenter ({ this.title, this.selectedItem, @required this.items, @required this.onPressed, this.toLabel });

  String _label(T selectedItem) {
    if (toLabel != null) {
      return toLabel(selectedItem);
    }
    return selectedItem.toString();
  }

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int position) {
        return Material(child: InkWell(
          child: Container(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        _label(this.items[position]),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: Fonts.ubuntu
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 10
                    ),
                    child: Visibility(
                      child: Icon(Icons.check, color: BrandColors.secondaryButtonColor, size: 18),
                      visible: selectedItem == items[position],
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: BrandColors.borderColor,
                    width: 1
                  )
                )
            ),
          ),
          onTap: () {
            onPressed(this.items[position]);
          },
        ), color: Colors.white);
      },
      itemCount: this.items.length,
    );
  }

  @override
  Widget header(BuildContext context) {
    if (this.title == null)
      return Container();

    return BottomSheetHeader(
      borderColor: BrandColors.borderColor,
      title: title,
    );
  }

}