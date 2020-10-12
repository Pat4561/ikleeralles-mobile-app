import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/badge.dart';
import 'package:ikleeralles/ui/hyperlink.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';

class ExerciseSetCell extends StatelessWidget {

  static const Color inputBackgroundColor = Color.fromRGBO(235, 235, 235, 1);
  static const double marginBetweenInputs = 8;
  static const double marginBetweenContainers = 15;

  final ExerciseSet set;
  final int rowNumber;
  final String term;
  final String definition;
  final Function(BuildContext context, { @required ExerciseSetInputSide side }) onAddNewEntryPressed;
  final Function(BuildContext context, String text, { @required int index, @required ExerciseSetInputSide side }) onFieldChange;
  final Function(BuildContext context, { @required int index, @required ExerciseSetInputSide side }) onDeleteField;
  final Function(BuildContext) onDeletePressed;

  ExerciseSetCell (this.set, { @required this.rowNumber, @required this.term, @required this.definition,
    @required this.onDeletePressed, @required this.onAddNewEntryPressed, @required this.onFieldChange, @required this.onDeleteField });

  Widget _topActionsBar(BuildContext context, { double badgeSize = 30, double marginBetweenContainers = marginBetweenContainers, double marginBetweenInputs = marginBetweenInputs }) {
    return Container(
      height: marginBetweenContainers + marginBetweenInputs,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: marginBetweenContainers + marginBetweenInputs,
            width: 70,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  child: IconBadge(
                    size: badgeSize,
                    backgroundColor: Colors.red,
                    iconBuilder: (BuildContext context) => Icon(Icons.delete, color: Colors.white, size: 18),
                    onPressed: () => onDeletePressed(context),
                  ),
                  top: badgeSize / 2 * -1,
                  right: 0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 14
        ),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.2,
                  blurRadius: 3
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              _RowNumberBadge(
                  badgeSize: 30,
                  badgeText: this.rowNumber.toString(),
                  containerWidth: 20,
                  containerHeight: 50
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _topActionsBar(context),
                      _SetEntriesInnerCol(
                        _SetEntries(set.original),
                        inputTypeLabel: this.term,
                        onFieldChange: (BuildContext context, String newText, { int index}) => onFieldChange(context, newText, side: ExerciseSetInputSide.term, index: index),
                        onDeleteField: (BuildContext context, { int index }) => onDeleteField(context, side: ExerciseSetInputSide.term, index: index),
                        onAddNewEntryPressed: (BuildContext context) => onAddNewEntryPressed(context, side: ExerciseSetInputSide.term)
                      ),
                      _SetEntriesInnerCol(
                        _SetEntries(set.translated),
                        inputTypeLabel: this.definition,
                        onFieldChange: (BuildContext context, String newText, { int index}) => onFieldChange(context, newText, side: ExerciseSetInputSide.definition, index: index),
                        onDeleteField: (BuildContext context, { int index }) => onDeleteField(context, side: ExerciseSetInputSide.definition, index: index),
                        onAddNewEntryPressed: (BuildContext context) => onAddNewEntryPressed(context, side: ExerciseSetInputSide.definition)
                      ),
                      Container(
                        height: marginBetweenContainers,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  width: 20
              ),
            ],
          ),
        )
    );
  }

}

class _RowNumberBadge extends StatelessWidget {

  final double containerWidth;
  final double containerHeight;
  final double badgeSize;
  final String badgeText;

  _RowNumberBadge({ this.containerWidth, this.containerHeight, this.badgeSize, this.badgeText });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: containerHeight,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            left: badgeSize / 2 * -1,
            top: (containerHeight - badgeSize) / 2,
            child: TextBadge(
              size: badgeSize,
              text: badgeText,
            ),
          )
        ],
      ),
    );
  }

}


class _SetEntries {

  List<String> _values;

  List<String> get values => _values;

  _SetEntries (List<String> entries) {
    _values = entries ?? [];
    if (_values.length == 0) {
      _values.add("");
    }
  }

}

class _SetEntriesInnerCol extends StatelessWidget {

  final String inputTypeLabel;
  final Function(BuildContext context) onAddNewEntryPressed;
  final Function(BuildContext context, String text, { @required int index }) onFieldChange;
  final Function(BuildContext context, { @required int index }) onDeleteField;
  final _SetEntries entries;

  _SetEntriesInnerCol (this.entries, { @required this.inputTypeLabel, @required this.onAddNewEntryPressed, @required this.onFieldChange, @required this.onDeleteField });

  Widget _exerciseSetInputTypeLabel(String text) {
    return Container(
      child: Text(text, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.ubuntu
      )),
      margin: EdgeInsets.only(bottom: ExerciseSetCell.marginBetweenInputs),
    );
  }

  Widget _textField(BuildContext context, String text, { @required Function onTextChange, bool shouldShowDelete = false, Function onDeleteField }) {

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          child: ThemedTextField(
              borderRadius: 5,
              textEditingController: TextEditingController(text: text),
              fillColor: ExerciseSetCell.inputBackgroundColor,
              borderColor: ExerciseSetCell.inputBackgroundColor,
              focusedColor: BrandColors.secondaryButtonColor,
              onChanged: onTextChange,
              borderWidth: 1,
              margin: EdgeInsets.only(
                  bottom: ExerciseSetCell.marginBetweenInputs
              ),
              contentPadding: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 20,
                  right: shouldShowDelete ? 66 : 20
              )
          ),
        ),
        Visibility(
          visible: shouldShowDelete,
          child: Container(
            width: 46,
            height: 40,
            child: Center(
              child: IconHyperlink(
                highlightedColor: BrandColors.secondaryButtonColor,
                baseColor: BrandColors.iconColorRed,
                iconData: Icons.delete_outline,
                onPressed: () => onDeleteField(),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: 8,
            ),
          ),
        )
      ],
    );
  }

  Widget _addNewEntryButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextHyperlink(
          title: "+ Synoniem",
          baseColor: BrandColors.secondaryButtonColor,
          highlightedColor: BrandColors.secondaryButtonColor.withOpacity(0.7),
          onPressed: () => onAddNewEntryPressed(context)
        )
      ],
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    List<Widget> children = [];
    children.add(_exerciseSetInputTypeLabel(inputTypeLabel));

    for (int i = 0; i < entries.values.length; i++) {
      children.add(
          _textField(
              context,
              entries.values[i],
              shouldShowDelete: entries.values.length > 1,
              onTextChange: (newValue) => onFieldChange(context, newValue, index: i),
              onDeleteField: () => onDeleteField(context, index: i)
          )
      );
    }

    children.add(_addNewEntryButton(context));
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildChildren(context),
    );
  }


}


