import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/badge.dart';
import 'package:ikleeralles/ui/bottomsheets/options.dart';
import 'package:ikleeralles/ui/hyperlink.dart';
import 'package:ikleeralles/ui/tables/base.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/themed/select.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';
import 'package:scoped_model/scoped_model.dart';

class ExerciseEditorPage extends StatefulWidget {

  final ExerciseList exerciseList;

  ExerciseEditorPage ({ this.exerciseList });

  @override
  State<StatefulWidget> createState() {
    return _ExerciseEditorPageState();
  }

}

class SetInputTypeProvider {

  String defaultValue() {
    return "Nederlands";
  }

  List<String> all() {
    return ["Nederlands", "Duits", "Frans"];
  }

}

class ExerciseListController {

  final SetInputTypeProvider termsProvider = SetInputTypeProvider();

  final SetInputTypeProvider definitionsProvider = SetInputTypeProvider();

  TextEditingController _titleTextController;
  TextEditingController get titleTextController => _titleTextController;

  ValueNotifier<String> _termValueNotifier;
  ValueNotifier<String> get termValueNotifier => _termValueNotifier;

  ValueNotifier<String> _definitionValueNotifier;
  ValueNotifier<String> get definitionValueNotifier => _definitionValueNotifier;

  ExerciseSetsController _setsController;
  ExerciseSetsController get setsController => _setsController;

  ExerciseListController.newList() {
    _titleTextController = TextEditingController();
    _termValueNotifier = ValueNotifier<String>(termsProvider.defaultValue());
    _definitionValueNotifier = ValueNotifier<String>(definitionsProvider.defaultValue());
    _setsController = ExerciseSetsController();
  }

  ExerciseListController.existingList(ExerciseList list) {
    _titleTextController = TextEditingController(text: list.name);
    _termValueNotifier = ValueNotifier<String>(list.original ?? termsProvider.defaultValue());
    _definitionValueNotifier = ValueNotifier<String>(list.translated ?? definitionsProvider.defaultValue());
    _setsController = ExerciseSetsController(sets: ExerciseDetails(list.content).sets);
  }

}

class ExerciseSetsController extends Model {

  static const int minSetLength = 5;
  static const int batchSize = 3;

  List<ExerciseSet> _sets;
  List<ExerciseSet> get sets => _sets;

  ExerciseSetsController ({ List<ExerciseSet> sets }) {
    _sets = sets ?? [];
    if (_sets.length < minSetLength) {
      _populateNew(till: minSetLength);
    }
  }

  void _populateNew({ @required int till }) {
    int start = _sets.length;
    int itemsToCreate = till - start;
    if (itemsToCreate > 0) {
      for (int i = 0; i < itemsToCreate; i++) {
        _sets.add(ExerciseSet.create());
      }
    }
  }

  void addMore() {
    _populateNew(till: _sets.length + batchSize);
    notifyListeners();
  }


}

class _ExerciseEditorSliverAppBar  extends StatelessWidget {

  final Function(BuildContext) onSaveTestPressed;
  final TextEditingController titleTextController;
  final ValueNotifier<String> termValueNotifier;
  final ValueNotifier<String> definitionValueNotifier;
  final List<String> termOptions;
  final List<String> definitionOptions;

  _ExerciseEditorSliverAppBar ({ @required this.onSaveTestPressed, @required this.titleTextController, @required this.termValueNotifier, @required List<String> this.termOptions,
    @required this.definitionValueNotifier, @required List<String> this.definitionOptions });

  Widget _buildOptionsButton(BuildContext context, ValueNotifier<String> valueNotifier, { @required String labelText, @required List<String> options }) {
    return ValueListenableBuilder<String>(
      valueListenable: valueNotifier,
      builder: (BuildContext context, String value, Widget widget) {
        return ThemedSelect(
            placeholder: value,
            labelText: labelText,
            radius: 4,
            height: 35,
            color: Colors.white.withOpacity(0.7),
            onPressed: (BuildContext context) {
              OptionsBottomSheetPresenter<String>(
                  title: labelText,
                  items: options,
                  selectedItem: valueNotifier.value,
                  onPressed: (item) {
                    valueNotifier.value = item;
                    Navigator.pop(context);
                  }
              ).show(context);
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 230,
      pinned: true,
      actions: <Widget>[
        Container(
          child: Center(
            child: ThemedButton(
              "Opslaan",
              buttonColor: BrandColors.secondaryButtonColor,
              icon: Icons.save,
              borderRadius: BorderRadius.circular(12),
              onPressed: () => onSaveTestPressed(context),
            ),
          ),
          margin: EdgeInsets.only(
              right: 20
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
                top: 55
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ThemedTextField(
                    borderRadius: 5,
                    labelText: "Titel",
                    textEditingController: titleTextController,
                    fillColor: Colors.white.withOpacity(0.7),
                    borderColor: Colors.white.withOpacity(0.7),
                    focusedColor: BrandColors.secondaryButtonColor,
                    borderWidth: 1,
                    margin: EdgeInsets.only(
                        bottom: 8,
                        top: 8
                    )
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildOptionsButton(context, termValueNotifier, labelText: "Term", options: termOptions)),
                    SizedBox(width: 20),
                    Expanded(child: _buildOptionsButton(context, definitionValueNotifier, labelText: "Definitie", options: definitionOptions)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _ExerciseEditorPageState extends State<ExerciseEditorPage> {

  ExerciseListController _exerciseListController;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.exerciseList != null) {
      _exerciseListController = ExerciseListController.existingList(widget.exerciseList);
    } else {
      _exerciseListController = ExerciseListController.newList();
    }
  }

  void _saveTest() {

  }

  void _startTest() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScroller) {
            return <Widget>[
              _ExerciseEditorSliverAppBar(
                definitionValueNotifier: _exerciseListController.definitionValueNotifier,
                termValueNotifier: _exerciseListController.termValueNotifier,
                onSaveTestPressed: (BuildContext context) => _saveTest(),
                titleTextController: _exerciseListController.titleTextController,
                termOptions: _exerciseListController.termsProvider.all(),
                definitionOptions: _exerciseListController.definitionsProvider.all(),
              )
            ];
          },
          body: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1));
            },
            child: _ExerciseEditorList(controller: _exerciseListController.setsController, definition: _exerciseListController.definitionValueNotifier.value, term: _exerciseListController.termValueNotifier.value),
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BrandColors.primaryButtonColor,
        onPressed: _startTest,
        child: Icon(Icons.play_circle_outline, size: 30),
      ),
    );
  }

}

class _ExerciseSetRowNumberBadge extends StatelessWidget {

  final double containerWidth;
  final double containerHeight;
  final double badgeSize;
  final String badgeText;

  _ExerciseSetRowNumberBadge({ this.containerWidth, this.containerHeight, this.badgeSize, this.badgeText });

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

class _ExerciseSetRowInnerCol extends StatefulWidget {

  final List<String> options;
  final String inputTypeLabel;

  _ExerciseSetRowInnerCol (this.options, { @required this.inputTypeLabel });

  @override
  State<StatefulWidget> createState() {
    return _ExerciseSetRowInnerColState();
  }

}

class _SetOption {

  TextEditingController _textEditingController;

  TextEditingController get textEditingController => _textEditingController;

  _SetOption (String text) {
    _textEditingController = TextEditingController(
      text: text
    );
  }

  static _SetOption create() {
    return _SetOption("");
  }

}

class _ExerciseSetRowInnerColState extends State<_ExerciseSetRowInnerCol> {

  List<_SetOption> _options;

  Widget _exerciseSetInputTypeLabel(String text) {
    return Container(
      child: Text(text, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.ubuntu
      )),
      margin: EdgeInsets.only(bottom: _ExerciseSetRow.marginBetweenInputs),
    );
  }

  //send event (create option, delete option, fill option)

  Widget _textField(_SetOption option) {
    return ThemedTextField(
        borderRadius: 5,
        fillColor: _ExerciseSetRow.inputBackgroundColor,
        borderColor: _ExerciseSetRow.inputBackgroundColor,
        focusedColor: BrandColors.secondaryButtonColor,
        borderWidth: 1,
        textEditingController: option.textEditingController,
        margin: EdgeInsets.only(
            bottom: _ExerciseSetRow.marginBetweenInputs
        )
    );
  }

  Widget _addNewOptionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextHyperlink(
          title: "+ Synoniem",
          baseColor: BrandColors.secondaryButtonColor,
          highlightedColor: BrandColors.secondaryButtonColor.withOpacity(0.7),
          onPressed: _addNewOption,
        )
      ],
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    List<Widget> children = [];
    children.add(_exerciseSetInputTypeLabel(widget.inputTypeLabel));
    children.addAll(_options.map((o) => _textField(o)).toList());
    children.add(_addNewOptionButton());
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

  void _addNewOption() {
    setState(() {
      _options.add(_SetOption.create());
    });
  }

  @override
  void initState() {
    _options = widget.options.map((v) => _SetOption(v)).toList();
    if (_options.length == 0) {
      _options.add(_SetOption.create());
    }
    super.initState();
  }

}

class _ExerciseSetRow extends StatelessWidget {

  static const Color inputBackgroundColor = Color.fromRGBO(235, 235, 235, 1);
  static const double marginBetweenInputs = 8;
  static const double marginBetweenContainers = 15;

  final ExerciseSet set;
  final int rowNumber;
  final String term;
  final String definition;

  _ExerciseSetRow (this.set, { @required this.rowNumber, @required this.term, @required this.definition });

  Widget _topActionsBar({ double badgeSize = 30, double marginBetweenContainers = marginBetweenContainers, double marginBetweenInputs = marginBetweenInputs }) {
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
                    onPressed: () {

                    },
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
            _ExerciseSetRowNumberBadge(
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
                    _topActionsBar(),
                    _ExerciseSetRowInnerCol(
                      set.original,
                      inputTypeLabel: this.term,
                    ),
                    _ExerciseSetRowInnerCol(
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

class _ExerciseEditorList extends StatelessWidget {

  final ExerciseSetsController controller;
  final String term;
  final String definition;

  _ExerciseEditorList ({ @required this.controller, @required this.term, @required this.definition });

  @override
  Widget build(BuildContext context) {
    return TableView(
      TableViewBuilder(
        sectionHeaderBuilder: (int section) {
          return Container(
            height: 10,
          );
        },
        numberOfRows: (int section) {
          return controller.sets.length;
        },
        itemBuilder: (BuildContext context, int row, int section) {
          return _ExerciseSetRow(
            controller.sets[row],
            rowNumber: row + 1,
            definition: definition,
            term: term,
          );
        },
        sectionFooterBuilder: (int section) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ThemedButton(
                    "Nieuwe velden",
                    buttonColor: Colors.white,
                    labelColor: BrandColors.textColorLighter,
                    fontSize: 15,
                    icon: Icons.add_circle_outline,
                    iconSize: 24,
                    contentPadding: EdgeInsets.all(12),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: BrandColors.borderColor
                    ),
                    onPressed: () => controller.addMore()
                )
              ],
            ),
          );
        }
      )
    );
  }

}
