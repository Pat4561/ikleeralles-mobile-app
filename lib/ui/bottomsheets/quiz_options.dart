import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/bottomsheets/presenter.dart';
import 'package:ikleeralles/ui/extensions/value_controller.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/extensions/group_controller.dart';

//TODO: All the translations
//TODO: Slider
//TODO: Switch
//TODO: Numeric input


class _QuizOptionsFragment extends StatefulWidget {

  final ExerciseList exerciseList;

  _QuizOptionsFragment (this.exerciseList);

  @override
  State<StatefulWidget> createState() {
    return _QuizOptionsFragmentState();
  }

}

class _DirectionTypeGenerator {

  final ExerciseList exerciseList;

  _DirectionTypeGenerator (this.exerciseList);

  List<String> generate(BuildContext context) {
    String original = "${exerciseList.original} - ${exerciseList.translated}";
    String translated = "${exerciseList.translated} - ${exerciseList.original}";
    String mixed = FlutterI18n.translate(context, TranslationKeys.mixed);
    return [original, translated, mixed];
  }

}

class _QuizOptionsUI {

  Widget _radioGroup(GroupController<Option> controller) {
    return controller.build(builder: (BuildContext context, { Option groupValue, List<Option> availableOptions, Function(Option) updateCallback }) {
      return RadioGroup<Option>.builder(
        direction: Axis.vertical,
        groupValue: groupValue,
        onChanged: (value) => updateCallback(value),
        items: availableOptions,
        itemBuilder: (item) => RadioButtonBuilder(
          item.toString(),
        ),
      );
    });
  }

  Widget _checkBoxRow(ValueController<bool> controller, { @required String label, double checkBoxSize = 16 }) {
    return Row(
      children: <Widget>[
        Container(child: SizedBox(
          width: checkBoxSize,
          height: checkBoxSize,
          child: controller.build(
              builder: (BuildContext context, { bool selectedValue, Function(bool) updateCallback }) {
                return Checkbox(
                    value: selectedValue,
                    activeColor: BrandColors.secondaryButtonColor,
                    onChanged: (newValue) => updateCallback(newValue)
                );
              }
          ),
        ), margin: EdgeInsets.only(right: 15)),
        Expanded(child: Text(
          label,
          style: TextStyle(
              fontSize: 14,
              fontFamily: Fonts.ubuntu
          ),
        ))
      ],
    );
  }

  Widget _captionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: Fonts.ubuntu,
          fontWeight: FontWeight.bold,
          fontSize: 14
      ),
    );
  }

}

class _QuizOptionsFragmentState extends State<_QuizOptionsFragment> with _QuizOptionsUI {



  GroupController<Option> _directionTypeController;
  ValueController<bool> _continueTillSuccessOptionController;
  ValueController<bool> _correctCapitalsOptionController;
  ValueController<bool> _correctAccentsOptionController;
  ValueController<bool> _showFirstLetterOptionController;
  ValueController<bool> _showVowelsOptionController;
  ValueController<bool> _enterToNextAnswerController;


  void initializeControllers() {
    _directionTypeController = GroupController<Option>(
        options: _DirectionTypeGenerator(widget.exerciseList).generate(context).asMap().map(
                (index, element) => MapEntry(index, Option(element, index))
        ).values.toList()
    );

    _continueTillSuccessOptionController = ValueController<bool>(true);
    _correctCapitalsOptionController = ValueController<bool>(true);
    _correctAccentsOptionController = ValueController<bool>(true);

    _showFirstLetterOptionController = ValueController<bool>(false);
    _showVowelsOptionController = ValueController<bool>(false);
    _enterToNextAnswerController = ValueController<bool>(false);
  }

  @override
  void initState() {
   super.initState();
   initializeControllers();
  }

  Widget _simpleOptionsSection(BuildContext context) {
    return Container(
      child: _radioGroup(
        _directionTypeController
      ),
    );
  }

  Widget _advancedOptionsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
              child: _captionLabel(context, FlutterI18n.translate(context, TranslationKeys.advancedSettings)),
              margin: EdgeInsets.only(bottom: 10),
          ),
          _checkBoxRow(_continueTillSuccessOptionController, label: FlutterI18n.translate(context, TranslationKeys.contineuTillSuccess)),
          _checkBoxRow(_correctCapitalsOptionController, label: FlutterI18n.translate(context, TranslationKeys.correctCapitals)),
          _checkBoxRow(_correctAccentsOptionController, label: FlutterI18n.translate(context, TranslationKeys.correctAccents)),
          _checkBoxRow(_showFirstLetterOptionController, label: FlutterI18n.translate(context, TranslationKeys.showFirstLetter)),
          _checkBoxRow(_showVowelsOptionController, label: FlutterI18n.translate(context, TranslationKeys.showVowels))
        ],
      ),
    );

  }

  Widget _quizSelectionOptionsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            child: _captionLabel(context, FlutterI18n.translate(context, TranslationKeys.quizSelection)),
            margin: EdgeInsets.only(bottom: 10),
          ),
          Container(
            child: //here comes the slider,
          )
        ],
      ),
    );
  }

  Widget _timeOptionsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Container(
            child: _captionLabel(context, FlutterI18n.translate(context, TranslationKeys.quizTimeOptions)),
            margin: EdgeInsets.only(bottom: 10),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: //numericInput,
                ),
                Spacer(),
                Container(
                  child: //numericInput,
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(
                horizontal: 15
            ),
          ),
          _checkBoxRow(_enterToNextAnswerController, label: FlutterI18n.translate(context, TranslationKeys.enterToNextAnswer)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _simpleOptionsSection(context),
        _advancedOptionsSection(context),
        _quizSelectionOptionsSection(context),
        _timeOptionsSection(context)
      ],
    );
  }

}

class QuizOptionsBottomSheetPresenter extends BottomSheetPresenter {

  final GlobalKey<_QuizOptionsFragmentState> quizOptionsFragmentKey = GlobalKey<_QuizOptionsFragmentState>();
  final ExerciseList exerciseList;
  final List<ExerciseSet> exerciseSets;

  QuizOptionsBottomSheetPresenter ({ @required this.exerciseList, @required this.exerciseSets }) : super();

  @override
  Widget header(BuildContext context) {
    return BottomSheetHeader(
      child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                child: Text(
                  FlutterI18n.translate(context, TranslationKeys.quizSettings),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: Fonts.ubuntu,
                  ),
                  textAlign: TextAlign.start,
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ]
      ),
    );
  }

  void _startQuiz() {

  }

  @override
  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: _QuizOptionsFragment(
                this.exerciseList
              ),
            )
          )
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 10),
          child: ThemedButton(
            FlutterI18n.translate(context, TranslationKeys.startQuiz),
            icon: Icons.play_circle_outline,
            fontSize: 16,
            iconSize: 20,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            onPressed: _startQuiz,
            buttonColor: BrandColors.primaryButtonColor,
          ),
        )
      ],
    );
  }


}