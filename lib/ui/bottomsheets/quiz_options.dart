import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

enum QuizDirectionType {
  originalToTranslation,
  translationToOriginal,
  mixed
}

class QuizDirection {

  final String hint;
  final String name;

  QuizDirection ({ @required this.name, @required this.hint});

}

class QuizDirectionTypeGenerator {

  final ExerciseList exerciseList;

  QuizDirectionTypeGenerator (this.exerciseList);

  Map<QuizDirectionType, QuizDirection> generate(BuildContext context) {
    String original = "${exerciseList.original} - ${exerciseList.translated}";
    String translated = "${exerciseList.translated} - ${exerciseList.original}";
    return {
      QuizDirectionType.originalToTranslation: QuizDirection(
          name: original,
          hint: FlutterI18n.translate(context, TranslationKeys.termToDefinition)
      ),
      QuizDirectionType.translationToOriginal: QuizDirection(
          name: translated,
          hint: FlutterI18n.translate(context, TranslationKeys.definitionToTerm)
      ),
      QuizDirectionType.mixed: QuizDirection(
        name: FlutterI18n.translate(context, TranslationKeys.mixed),
        hint: FlutterI18n.translate(context, TranslationKeys.bothDirections)
      )
    };
  }

}

class QuizInput {

  final List<ExerciseList> exerciseLists;

  QuizDirectionTypeGenerator _directionTypeGenerator;

  Map<QuizDirectionType, QuizDirection> _directionNamesMap;

  Map<ExerciseList, ExerciseDetails> _questionsInfo = Map<ExerciseList, ExerciseDetails>();

  QuizInput (this.exerciseLists) {
    _directionTypeGenerator = QuizDirectionTypeGenerator(this.exerciseLists.first);
  }

  void initialize(BuildContext context) {
    for (ExerciseList exerciseList in this.exerciseLists) {
      _questionsInfo[exerciseList] = ExerciseDetails(exerciseList.content);
    }
    _directionNamesMap = _directionTypeGenerator.generate(context);
  }

  Map<QuizDirectionType, QuizDirection> get directionNamesMapping => _directionNamesMap;

  int get questionsCount {
    int sum = 0;
    _questionsInfo.forEach((k, v) => sum += v.sets.length);
    return sum;
  }

  int get divisions {
    int count = this.questionsCount;
    if (count < 10) {
      return 2;
    } else if (count < 30) {
      return 5;
    } else {
      return 10;
    }
  }


}

class _QuizOptionsFragment extends StatefulWidget {

  final QuizInput quizInput;

  _QuizOptionsFragment (this.quizInput);

  @override
  State<StatefulWidget> createState() {
    return _QuizOptionsFragmentState();
  }

}






class _QuizOptionsUI {

  Widget _radioGroup(GroupController<Option> controller) {
    return controller.build(builder: (BuildContext context, { Option groupValue, List<Option> availableOptions, Function(Option) updateCallback }) {
      return Column(
        children: () {
          return availableOptions.map((option) {
            return Container(
              child: _radioRow(
                  option: option,
                  groupValue: groupValue,
                  updateCallback: updateCallback
              ),
              margin: EdgeInsets.only(
                bottom: 6,
                top: 6
              ),
            );
          }).toList();
        }(),
      );
    });
  }

  Widget _radioRow({ @required Option option, @required Option groupValue, @required Function(Option) updateCallback, double checkBoxSize = 30 }) {
    return Row(
      children: <Widget>[
        Container(child: SizedBox(
          width: checkBoxSize,
          height: checkBoxSize,
          child: Center(
            child: Radio(
              activeColor: BrandColors.secondaryButtonColor,
              value: option,
              groupValue: groupValue,
              onChanged: (value) => updateCallback(value),
            ),
          ),
        ), margin: EdgeInsets.only(right: 15)),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(option.name, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.ubuntu,
                    fontSize: 14
                )),
                Visibility(
                  visible: option.description != null,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 8
                    ),
                    child: Text(option.description ?? "", style: TextStyle(
                        fontFamily: Fonts.ubuntu,
                        fontSize: 12
                    )),
                  )
                )
              ],
            )
        )
      ],
    );
  }

  Widget _checkBoxRow(ValueController<bool> controller, { @required String label, double checkBoxSize = 30 }) {
    return Row(
      children: <Widget>[
        Container(child: SizedBox(
          width: checkBoxSize,
          height: checkBoxSize,
          child: Center(
            child: controller.build(
                builder: (BuildContext context, { bool selectedValue, Function(bool) updateCallback }) {
                  return Checkbox(
                      value: selectedValue,
                      activeColor: BrandColors.secondaryButtonColor,
                      onChanged: (newValue) => updateCallback(newValue)
                  );
                }
            ),
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
  ValueController<RangeValues> _selectionRangeController;


  void initializeControllers() {
    
    _directionTypeController = GroupController<Option>(
      options: [
        Option(
            widget.quizInput.directionNamesMapping[QuizDirectionType.translationToOriginal].name,
            0,
            description: widget.quizInput.directionNamesMapping[QuizDirectionType.translationToOriginal].hint),
        Option(
            widget.quizInput.directionNamesMapping[QuizDirectionType.originalToTranslation].name,
            1,
            description: widget.quizInput.directionNamesMapping[QuizDirectionType.originalToTranslation].hint
        ),
        Option(
          widget.quizInput.directionNamesMapping[QuizDirectionType.mixed].name,
          2,
          description: widget.quizInput.directionNamesMapping[QuizDirectionType.mixed].hint
        )
      ]
    );

    _continueTillSuccessOptionController = ValueController<bool>(true);
    _correctCapitalsOptionController = ValueController<bool>(true);
    _correctAccentsOptionController = ValueController<bool>(true);

    _showFirstLetterOptionController = ValueController<bool>(false);
    _showVowelsOptionController = ValueController<bool>(false);
    _enterToNextAnswerController = ValueController<bool>(false);

    _selectionRangeController = ValueController<RangeValues>(RangeValues(
      1,
      widget.quizInput.questionsCount.toDouble()
    ));
  }

  @override
  void initState() {
   initializeControllers();
   super.initState();
  }

  Widget _simpleOptionsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: _radioGroup(
        _directionTypeController
      ),
    );
  }

  Widget _advancedOptionsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: _captionLabel(context, FlutterI18n.translate(context, TranslationKeys.advancedSettings)),
              margin: EdgeInsets.only(bottom: 20),
          ),
          Container(
            child: _checkBoxRow(_continueTillSuccessOptionController, label: FlutterI18n.translate(context, TranslationKeys.continueTillSuccess)),
            margin: EdgeInsets.only(
              bottom: 8
            ),
          ),
          Container(
            child: _checkBoxRow(_correctCapitalsOptionController, label: FlutterI18n.translate(context, TranslationKeys.correctCapitals)),
            margin: EdgeInsets.only(
                bottom: 8
            ),
          ),
          Container(
            child: _checkBoxRow(_correctAccentsOptionController, label: FlutterI18n.translate(context, TranslationKeys.correctAccents)),
            margin: EdgeInsets.only(
                bottom: 8
            ),
          ),
          Container(
            child: _checkBoxRow(_showFirstLetterOptionController, label: FlutterI18n.translate(context, TranslationKeys.showFirstLetter)),
            margin: EdgeInsets.only(
                bottom: 8
            ),
          ),
          Container(
            child: _checkBoxRow(_showVowelsOptionController, label: FlutterI18n.translate(context, TranslationKeys.showVowels)),
            margin: EdgeInsets.only(
                bottom: 8
            ),
          )
        ],
      ),
    );

  }

  Widget _quizSelectionOptionsSection(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: _captionLabel(context, FlutterI18n.translate(context, TranslationKeys.quizSelection)),
          ),
          Container(
            child: _selectionRangeController.build(
                builder: (BuildContext context, { RangeValues selectedValue, Function(RangeValues) updateCallback }) {
                  double max = widget.quizInput.questionsCount.toDouble();
                  return RangeSlider(
                    values: selectedValue,
                    activeColor: BrandColors.secondaryButtonColor,
                    inactiveColor: BrandColors.secondaryButtonColor.withOpacity(0.4),
                    min: 1,
                    max: max,
                    divisions: widget.quizInput.divisions,
                    labels: RangeLabels(
                        selectedValue.start.round().toString(),
                        selectedValue.end.round().toString()
                    ),
                    onChanged: (rangeValues) => updateCallback(rangeValues),
                  );
                }
            )
          )
        ],
      ),
    );
  }

  Widget _timeOptionsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: _captionLabel(context, FlutterI18n.translate(context, TranslationKeys.quizTimeOptions)),
            margin: EdgeInsets.only(bottom: 10),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(),
                Spacer(),
                Container(),
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

  final QuizInput quizInput;

  QuizOptionsBottomSheetPresenter ({ @required this.quizInput }) : super();

  @override
  Widget header(BuildContext context) {
    return BottomSheetHeader(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20
      ),
      borderColor: BrandColors.borderColor.withOpacity(0.5),
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
                this.quizInput
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