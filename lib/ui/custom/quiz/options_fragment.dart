import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/options.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/ui/dialogs/premium_lock.dart';
import 'package:ikleeralles/ui/extensions/value_controller.dart';
import 'package:ikleeralles/ui/numeric_input.dart';
import 'package:ikleeralles/ui/extensions/group_controller.dart';
import 'package:ikleeralles/ui/themed/button.dart';

class QuizOptionsFragment extends StatefulWidget {

  final QuizInput quizInput;

  final Function(BuildContext) onExpand;

  QuizOptionsFragment (this.quizInput, { this.onExpand, GlobalKey<QuizOptionsFragmentState> key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuizOptionsFragmentState();
  }

}


class _QuizOptionsUI {

  Widget _radioGroup<T>(GroupController<CustomOption<T>> controller) {
    return controller.build(builder: (BuildContext context, { CustomOption<T> groupValue, List<CustomOption<T>> availableOptions, Function(CustomOption<T>) updateCallback }) {
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

  Widget _radioRow<T>({ @required CustomOption<T> option, @required CustomOption<T> groupValue, @required Function(CustomOption<T>) updateCallback, double checkBoxSize = 30 }) {
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

  Widget _checkBoxRow(ValueController<bool> controller, { @required String label, double checkBoxSize = 30, Function(bool, Function(bool)) outerUpdateCallback }) {
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
                      onChanged: (newValue) {
                        if (outerUpdateCallback != null) {
                          outerUpdateCallback(selectedValue, updateCallback);
                        } else {
                          updateCallback(selectedValue);
                        }
                      }
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

class QuizOptionsFragmentData {

  QuizDirectionType directionType;
  QuizSelectionRange range;
  QuizHintOptions hintOptions;
  QuizCorrectionOptions correctionOptions;
  QuizMainOptions mainOptions;
  QuizQuestionVisibilityOptions visibilityOptions;

  QuizOptionsFragmentData ({ @required this.directionType, @required this.range, @required this.hintOptions, @required this.correctionOptions, @required this.mainOptions, @required this.visibilityOptions });

}

class QuizOptionsFragmentState extends State<QuizOptionsFragment> with _QuizOptionsUI {

  GroupController<CustomOption<QuizDirectionType>> _directionTypeController;
  ValueController<bool> _continueTillSuccessOptionController;
  ValueController<bool> _correctCapitalsOptionController;
  ValueController<bool> _correctAccentsOptionController;
  ValueController<bool> _showFirstLetterOptionController;
  ValueController<bool> _showVowelsOptionController;
  ValueController<bool> _enterToNextAnswerController;
  ValueController<RangeValues> _selectionRangeController;
  ValueController<int> _timeCorrectAnswerController;
  ValueController<int> _timeIncorrectAnswerController;

  final PremiumLocker _premiumLocker = PremiumLocker();

  bool _showAdvanced = false;

  QuizOptionsFragmentData getData() {
    return QuizOptionsFragmentData(
      mainOptions: QuizMainOptions(
        repeatQuestionsTillAllCorrect: _continueTillSuccessOptionController.value
      ),
      range: QuizSelectionRange(
        startIndex: _selectionRangeController.value.start.toInt() - 1,
        endIndex:  _selectionRangeController.value.end.toInt() - 1
      ),
      visibilityOptions: QuizQuestionVisibilityOptions(
        useEnterToGoToNext: _enterToNextAnswerController.value,
        timeCorrectAnswerVisible: _timeCorrectAnswerController.value,
        timeIncorrectAnswerVisible: _timeIncorrectAnswerController.value
      ),
      directionType: _directionTypeController.value.key,
      hintOptions: QuizHintOptions(
        showVowelsAsHint: _showVowelsOptionController.value,
        showFirstLetterAsHint: _showFirstLetterOptionController.value
      ),
      correctionOptions: QuizCorrectionOptions(
        correctAccents: _correctAccentsOptionController.value,
        correctCapitals: _correctCapitalsOptionController.value
      )
    );
  }

  void initializeControllers() {


    _directionTypeController = GroupController<CustomOption<QuizDirectionType>>(
        options: [
          CustomOption<QuizDirectionType>(
              widget.quizInput.directionNamesMapping[QuizDirectionType.translationToOriginal].name,
              QuizDirectionType.translationToOriginal,
              description: widget.quizInput.directionNamesMapping[QuizDirectionType.translationToOriginal].hint),
          CustomOption<QuizDirectionType>(
              widget.quizInput.directionNamesMapping[QuizDirectionType.originalToTranslation].name,
              QuizDirectionType.originalToTranslation,
              description: widget.quizInput.directionNamesMapping[QuizDirectionType.originalToTranslation].hint
          ),
          CustomOption<QuizDirectionType>(
              widget.quizInput.directionNamesMapping[QuizDirectionType.mixed].name,
              QuizDirectionType.mixed,
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

    _timeCorrectAnswerController = ValueController<int>(2);
    _timeIncorrectAnswerController = ValueController<int>(2);

    _selectionRangeController = ValueController<RangeValues>(RangeValues(
        1,
        widget.quizInput.count(directionType: _directionTypeController.value.key).toDouble()
    ));

    _directionTypeController.onChange(() {
      _selectionRangeController.notify(
        value: RangeValues(
            1,
            widget.quizInput.count(directionType: _directionTypeController.value.key).toDouble()
        )
      );
    });
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  Widget _simpleOptionsSection(BuildContext context) {
    return Container(
      padding: _showAdvanced ? EdgeInsets.all(15) : EdgeInsets.only(top: 15, bottom: 0, left: 15, right: 15),
      child: _radioGroup<QuizDirectionType>(
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
                    double max = widget.quizInput.count(directionType: _directionTypeController.value.key).toDouble();
                    return RangeSlider(
                      values: selectedValue,
                      activeColor: BrandColors.secondaryButtonColor,
                      inactiveColor: BrandColors.secondaryButtonColor.withOpacity(0.4),
                      min: 1,
                      max: max,
                      divisions: widget.quizInput.divisions(directionType: _directionTypeController.value.key),
                      labels: RangeLabels(
                          selectedValue.start.round().toString(),
                          selectedValue.end.round().toString()
                      ),
                      onChanged: (rangeValues) {
                        updateCallback(rangeValues);

                        if (!_premiumLocker.isPremium) {
                          _premiumLocker.schedulePresentation(
                              context,
                              undoAction: () {
                                updateCallback(RangeValues(1, max));
                              }
                          );
                        }


                      },
                    );
                  }
              )
          )
        ],
      ),
    );
  }

  Widget _numericInput(String labelText, ValueController<int> controller) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(labelText, style: TextStyle(
              fontFamily: Fonts.ubuntu,
              fontSize: 15
          )),
          margin: EdgeInsets.only(
              bottom: 15
          ),
        ),
        ClipRRect(
          child: controller.build(builder: (BuildContext context, { int selectedValue, Function(int) updateCallback }) {
            return NumericInput(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey.withOpacity(0.3)
              ),
              value: selectedValue,
              midSectionDecoration: BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1)
              ),
              onLeftButtonPressed: (BuildContext context) {
                if (!_premiumLocker.isPremium) {
                  _premiumLocker.schedulePresentation(
                      context
                  );
                } else {
                  if (selectedValue - 1 > 0) {
                    updateCallback(selectedValue - 1);
                  }
                }

              },
              onRightButtonPressed: (BuildContext context) {
                if (!_premiumLocker.isPremium) {
                  _premiumLocker.schedulePresentation(
                      context
                  );
                } else {
                  updateCallback(selectedValue + 1);
                }
              },
              textStyle: TextStyle(
                  fontFamily: Fonts.ubuntu,
                  fontSize: 15
              ),
            );
          }),
          borderRadius: BorderRadius.circular(10),
        )
      ],
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
                Container(
                  child: _numericInput(FlutterI18n.translate(context, TranslationKeys.timeCorrectAnswer), this._timeCorrectAnswerController),
                ),
                Spacer(),
                Container(
                  child: _numericInput(FlutterI18n.translate(context, TranslationKeys.timeIncorrectAnswer), this._timeIncorrectAnswerController),
                ),
              ],
            ),
            margin: EdgeInsets.only(
                top: 10,
                bottom: 15
            ),
          ),
          _checkBoxRow(
              _enterToNextAnswerController,
              label: FlutterI18n.translate(context, TranslationKeys.enterToNextAnswer),
              outerUpdateCallback: (bool isSelected, Function(bool) updateCallback) {
                if (!_premiumLocker.isPremium) {
                  _premiumLocker.schedulePresentation(
                      context
                  );
                } else {
                  updateCallback(isSelected);
                }
              }
          ),
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
        Visibility(
          visible: !_showAdvanced,
          child: Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 0,
              bottom: 0
            ),
            child: Row(
              children: <Widget>[
                ThemedButton(
                  FlutterI18n.translate(context, TranslationKeys.showMore),
                  buttonColor: BrandColors.secondaryButtonColor,
                  filled: false,
                  fontSize: 13,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20
                  ),
                  borderRadius: BorderRadius.circular(15),
                  onPressed: () {
                    setState(() {
                      _showAdvanced = true;
                      if (widget.onExpand != null) {
                        widget.onExpand(context);
                      }
                    });
                  },
                ),
              ],
            )
          ),
        ),
        Visibility(
          visible: _showAdvanced,
          child: _advancedOptionsSection(context),
        ),
        Visibility(
          visible: _showAdvanced,
          child: _quizSelectionOptionsSection(context),
        ),
        Visibility(
          visible: _showAdvanced,
          child: _timeOptionsSection(context),
        )
      ],
    );
  }

}