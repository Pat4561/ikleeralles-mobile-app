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
  final Function(BuildContext) onDeletePressed;

  ExerciseSetCell (this.set, { @required this.rowNumber, @required this.term, @required this.definition, @required this.onDeletePressed });

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
                        set.original,
                        inputTypeLabel: this.term,
                      ),
                      _SetEntriesInnerCol(
                        set.translated,
                        inputTypeLabel: this.definition,
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

class _SetFieldEntry {

  TextEditingController _textEditingController;

  TextEditingController get textEditingController => _textEditingController;

  _SetFieldEntry (String text) {
    _textEditingController = TextEditingController(
        text: text
    );
  }

  static _SetFieldEntry create() {
    return _SetFieldEntry("");
  }

}

class _SetEntriesInnerCol extends StatefulWidget {

  final List<String> entries;
  final String inputTypeLabel;

  _SetEntriesInnerCol (this.entries, { @required this.inputTypeLabel });

  @override
  State<StatefulWidget> createState() {
    return _SetEntriesInnerColState();
  }

}

class _SetEntriesInnerColState extends State<_SetEntriesInnerCol> {

  List<_SetFieldEntry> _fieldEntries;

  Widget _exerciseSetInputTypeLabel(String text) {
    return Container(
      child: Text(text, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.ubuntu
      )),
      margin: EdgeInsets.only(bottom: ExerciseSetCell.marginBetweenInputs),
    );
  }


  Widget _textField(_SetFieldEntry entry) {
    return ThemedTextField(
        borderRadius: 5,
        fillColor: ExerciseSetCell.inputBackgroundColor,
        borderColor: ExerciseSetCell.inputBackgroundColor,
        focusedColor: BrandColors.secondaryButtonColor,
        borderWidth: 1,
        textEditingController: entry.textEditingController,
        margin: EdgeInsets.only(
            bottom: ExerciseSetCell.marginBetweenInputs
        )
    );
  }

  Widget _addNewEntryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextHyperlink(
          title: "+ Synoniem",
          baseColor: BrandColors.secondaryButtonColor,
          highlightedColor: BrandColors.secondaryButtonColor.withOpacity(0.7),
          onPressed: _addNewEntry,
        )
      ],
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    List<Widget> children = [];
    children.add(_exerciseSetInputTypeLabel(widget.inputTypeLabel));
    children.addAll(_fieldEntries.map((o) => _textField(o)).toList());
    children.add(_addNewEntryButton());
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

  void _addNewEntry() {
    setState(() {
      _fieldEntries.add(_SetFieldEntry.create());
    });
  }

  @override
  void initState() {
    _fieldEntries = widget.entries.map((v) => _SetFieldEntry(v)).toList();
    if (_fieldEntries.length == 0) {
      _fieldEntries.add(_SetFieldEntry.create());
    }
    super.initState();
  }

}

