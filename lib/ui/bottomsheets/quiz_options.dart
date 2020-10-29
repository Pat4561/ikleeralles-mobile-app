import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/options.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/pages/quiz.dart';
import 'package:ikleeralles/ui/bottomsheets/presenter.dart';
import 'package:ikleeralles/ui/custom/quiz/builder.dart';
import 'package:ikleeralles/ui/expandable_container.dart';
import 'package:ikleeralles/ui/custom/quiz/options_fragment.dart';
import 'package:ikleeralles/ui/segmented_control.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/extensions/group_controller.dart';

class QuizOptionsBottomSheetHeader extends StatefulWidget {

  final QuizInput quizInput;

  QuizOptionsBottomSheetHeader (this.quizInput, { GlobalKey<QuizOptionsHeaderState> key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuizOptionsHeaderState();
  }

}

class QuizOptionsHeaderData {

  final QuizType quizType;

  QuizOptionsHeaderData({ this.quizType });

}

class QuizOptionsHeaderState extends State<QuizOptionsBottomSheetHeader> {

  GroupController<CustomOption<QuizType>> _quizTypeController;

  Widget _quizTypeControl(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(220, 220, 220, 1),
            borderRadius: BorderRadius.circular(10)
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _quizTypeController.build(
              builder: (BuildContext context, { CustomOption<QuizType> groupValue, List<CustomOption<QuizType>> availableOptions, Function(CustomOption<QuizType>) updateCallback }) {
                return SegmentedControl<CustomOption<QuizType>>(
                  options: availableOptions,
                  selectedValue: groupValue,
                  elementBuilder: (BuildContext context, CustomOption<QuizType> value, bool isSelected){
                    return SegmentedControlElement(
                      value.toString(),
                      onPressed: () => updateCallback(value),
                      activeColor: BrandColors.secondaryButtonColor,
                      isSelected: isSelected,
                      activeTextColor: Colors.white,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.ubuntu,
                      ),
                    );
                  },
                );
              }
            )
        )
    );
  }

  @override
  void initState() {
    super.initState();

    _quizTypeController =  GroupController<CustomOption<QuizType>>(
        options: [
          CustomOption<QuizType>(
            widget.quizInput.quizTypes[QuizType.quiz],
            QuizType.quiz
          ),
          CustomOption<QuizType>(
              widget.quizInput.quizTypes[QuizType.inMind],
              QuizType.inMind
          )
        ]
    );

  }

  QuizOptionsHeaderData getData() {
    return QuizOptionsHeaderData(quizType: this._quizTypeController.value.key);
  }

  @override
  Widget build(BuildContext context) {
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
            _quizTypeControl(context)
          ]
      ),
    );
  }

}

class QuizOptionsBottomSheetPresenter extends BottomSheetPresenter {

  final GlobalKey<QuizOptionsFragmentState> quizOptionsFragmentKey = GlobalKey<QuizOptionsFragmentState>();

  final GlobalKey<QuizOptionsHeaderState> quizOptionsHeaderKey = GlobalKey<QuizOptionsHeaderState>();

  final GlobalKey<ExpandableContainerState> expansionContainerKey = GlobalKey<ExpandableContainerState>();

  final QuizInput quizInput;

  QuizOptionsBottomSheetPresenter ({ @required this.quizInput }) : super();

  @override
  Widget header(BuildContext context) {
    return QuizOptionsBottomSheetHeader(quizInput, key: quizOptionsHeaderKey);
  }

  void show(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ExpandableContainer(
            key: expansionContainerKey,
            unExpandedHeight: MediaQuery.of(context).size.height * 0.5,
            expandedHeight: MediaQuery.of(context).size.height * 0.9,
            builder: (BuildContext context, { bool isExpanded}) {
              return builder(context);
            },
          );
        },
        context: context
    );
  }

  void _startQuiz(BuildContext context) {
    var headerResult = quizOptionsHeaderKey.currentState.getData();
    var fragmentResult = quizOptionsFragmentKey.currentState.getData();
    var options = QuizOptions(
      quizType: headerResult.quizType,
      directionType: fragmentResult.directionType,
      correctionOptions: fragmentResult.correctionOptions,
      hintOptions: fragmentResult.hintOptions,
      mainOptions: fragmentResult.mainOptions,
      range: fragmentResult.range,
      visibilityOptions: fragmentResult.visibilityOptions
    );

    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return QuizPage(
          builder:  QuizBuilder.create(
              options: options,
              quizInput: quizInput
          )
        );
      }
    ));
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: QuizOptionsFragment(
                this.quizInput,
                onExpand: (BuildContext context) {
                  expansionContainerKey.currentState.expand();
                },
                key: quizOptionsFragmentKey
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
            onPressed: () => _startQuiz(context),
            buttonColor: BrandColors.primaryButtonColor,
          ),
        )
      ],
    );
  }


}