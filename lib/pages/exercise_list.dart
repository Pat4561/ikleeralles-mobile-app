
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/managers/platform.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/bottomsheets/options.dart';
import 'package:ikleeralles/ui/bottomsheets/quiz_options.dart';
import 'package:ikleeralles/ui/custom/exercise_controller.dart';
import 'package:ikleeralles/ui/logout_handler.dart';
import 'package:ikleeralles/ui/tables/exercise_editor.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/themed/select.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';
import 'package:scoped_model/scoped_model.dart';

class _ReadOnlySliverAppBar extends StatelessWidget {

  final String definition;
  final String term;
  final String title;
  final PlatformDataProvider platformDataProvider;
  final Function(BuildContext) onCopyTestPressed;

  _ReadOnlySliverAppBar ({ @required this.definition, @required this.term, @required this.title, @required this.onCopyTestPressed, @required this.platformDataProvider });

  Widget _labelBox(String labelText, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(labelText, style: TextStyle(
              color: Colors.white,
              fontFamily: Fonts.ubuntu,
              fontSize: 15,
              fontWeight: FontWeight.bold
          )),
          SizedBox(height: 5),
          Text(value, style: TextStyle(
              color: Colors.white,
              fontFamily: Fonts.ubuntu,
              fontSize: 14
          ))
        ],
      ),
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
              FlutterI18n.translate(context, TranslationKeys.copy),
              buttonColor: BrandColors.secondaryButtonColor,
              icon: Icons.content_copy,
              borderRadius: BorderRadius.circular(12),
              onPressed: () => onCopyTestPressed(context),
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
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            padding: EdgeInsets.only(
              top: 55
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: Fonts.ubuntu,
                      fontSize: 26,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(child: _labelBox(FlutterI18n.translate(context, TranslationKeys.term), platformDataProvider.languageData.get(term))),
                    SizedBox(width: 20),
                    Expanded(child: _labelBox(FlutterI18n.translate(context, TranslationKeys.definition), platformDataProvider.languageData.get(definition)))
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

class _EditableSliverAppBar  extends StatelessWidget {

  final Function(BuildContext) onSaveTestPressed;
  final TextEditingController titleTextController;
  final ValueNotifier<String> termValueNotifier;
  final ValueNotifier<String> definitionValueNotifier;
  final PlatformDataProvider platformDataProvider;
  final List<String> termOptions;
  final List<String> definitionOptions;

  _EditableSliverAppBar ({ @required this.onSaveTestPressed, @required this.titleTextController, @required this.termValueNotifier, @required this.termOptions,
    @required this.definitionValueNotifier, @required this.definitionOptions, @required this.platformDataProvider });

  Widget _buildOptionsButton(BuildContext context, ValueNotifier<String> valueNotifier, { @required String labelText, @required List<String> options }) {
    return ValueListenableBuilder<String>(
      valueListenable: valueNotifier,
      builder: (BuildContext context, String value, Widget widget) {
        return ThemedSelect(
            placeholder: platformDataProvider.languageData.get(value),
            labelText: labelText,
            radius: 4,
            height: 35,
            color: Colors.white.withOpacity(0.7),
            onPressed: (BuildContext context) {
              OptionsBottomSheetPresenter<String>(
                  title: labelText,
                  items: options,
                  selectedItem: valueNotifier.value,
                  toLabel: (value) => platformDataProvider.languageData.get(value),
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
              FlutterI18n.translate(context, TranslationKeys.save),
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
                    labelText: FlutterI18n.translate(context, TranslationKeys.title),
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
                    Expanded(child: _buildOptionsButton(context, termValueNotifier, labelText: FlutterI18n.translate(context, TranslationKeys.term), options: termOptions)),
                    SizedBox(width: 20),
                    Expanded(child: _buildOptionsButton(context, definitionValueNotifier, labelText: FlutterI18n.translate(context, TranslationKeys.definition), options: definitionOptions)),
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

class ExerciseEditorPage extends StatefulWidget {

  final ExerciseList exerciseList;
  final bool readOnly;
  final PlatformDataProvider platformDataProvider;

  ExerciseEditorPage ({ this.exerciseList, this.readOnly = false, @required this.platformDataProvider });

  @override
  State<StatefulWidget> createState() {
    return _ExerciseEditorPageState();
  }

}

class _ExerciseEditorPageState extends State<ExerciseEditorPage> {

  ExerciseListController _exerciseListController;

  ExerciseEditorActionsHandler _exerciseEditorActionsHandler;

  LogoutHandler _logoutHandler;

  @override
  void initState() {
    _logoutHandler = LogoutHandler(context);
    _logoutHandler.listen();
    _initializeController();
    _initializeEditorHandler();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _logoutHandler.unListen();
  }

  void _initializeController() {
    if (widget.exerciseList != null) {
      _exerciseListController = ExerciseListController.existingList(widget.exerciseList, platformDataProvider: widget.platformDataProvider);
    } else {
      _exerciseListController = ExerciseListController.newList(platformDataProvider: widget.platformDataProvider);
    }
    _exerciseListController.readOnly = widget.readOnly;
  }

  void _initializeEditorHandler() {
    _exerciseEditorActionsHandler = ExerciseEditorActionsHandler(_exerciseListController);
  }

  void _startTest() {
    var quizInput = QuizInput([_exerciseListController.currentList(context)], platformDataProvider: widget.platformDataProvider);
    quizInput.initialize(context);
    QuizOptionsBottomSheetPresenter(
        quizInput: quizInput
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScroller) {

            if (_exerciseListController.readOnly) {
              return <Widget>[_ReadOnlySliverAppBar(
                title: _exerciseListController.titleTextController.text,
                term: _exerciseListController.termValueNotifier.value,
                definition: _exerciseListController.definitionValueNotifier.value,
                platformDataProvider: widget.platformDataProvider,
                onCopyTestPressed: (BuildContext context) {
                  _exerciseEditorActionsHandler.copyList(context, widget.platformDataProvider);
                },
              )];
            } else {
              return <Widget>[
                _EditableSliverAppBar(
                  definitionValueNotifier: _exerciseListController.definitionValueNotifier,
                  termValueNotifier: _exerciseListController.termValueNotifier,
                  onSaveTestPressed: (BuildContext context) => _exerciseEditorActionsHandler.saveList(context),
                  titleTextController: _exerciseListController.titleTextController,
                  termOptions: _exerciseListController.termsProvider.allKeys(),
                  definitionOptions: _exerciseListController.definitionsProvider.allKeys(),
                  platformDataProvider: widget.platformDataProvider,
                )
              ];
            }
          },
          body: RefreshIndicator(
            onRefresh: () async {
              return _exerciseEditorActionsHandler.performRefresh(context);
            },
            child: ScopedModel<ExerciseSetsController>(
              model: _exerciseListController.setsController,
              child: ScopedModelDescendant<ExerciseSetsController>(
                builder: (BuildContext context, Widget widget, ExerciseSetsController controller) {
                  return ExerciseEditorList(
                      controller: _exerciseListController.setsController,
                      definition: _exerciseListController.definitionValueNotifier.value,
                      term: _exerciseListController.termValueNotifier.value
                  );
                },
              ),
            ),
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

