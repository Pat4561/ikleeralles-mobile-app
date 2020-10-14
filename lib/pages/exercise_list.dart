import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/bottomsheets/options.dart';
import 'package:ikleeralles/ui/exercise_controller.dart';
import 'package:ikleeralles/ui/snackbar.dart';
import 'package:ikleeralles/ui/tables/exercise_editor.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/themed/select.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';
import 'package:scoped_model/scoped_model.dart';

class _ReadOnlySliverAppBar extends StatelessWidget {

  final String definition;
  final String term;
  final String title;
  final Function(BuildContext) onCopyTestPressed;

  _ReadOnlySliverAppBar ({ @required this.definition, @required this.term, @required this.title, @required this.onCopyTestPressed });

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
                    Expanded(child: _labelBox(FlutterI18n.translate(context, TranslationKeys.term), term)),
                    SizedBox(width: 20),
                    Expanded(child: _labelBox(FlutterI18n.translate(context, TranslationKeys.definition), definition))
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
  final List<String> termOptions;
  final List<String> definitionOptions;

  _EditableSliverAppBar ({ @required this.onSaveTestPressed, @required this.titleTextController, @required this.termValueNotifier, @required this.termOptions,
    @required this.definitionValueNotifier, @required this.definitionOptions });

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

  ExerciseEditorPage ({ this.exerciseList, this.readOnly = false });

  @override
  State<StatefulWidget> createState() {
    return _ExerciseEditorPageState();
  }

}

class _ExerciseEditorPageState extends State<ExerciseEditorPage> {

  ExerciseListController _exerciseListController;

  ExerciseEditorActionsHandler _exerciseEditorActionsHandler;

  @override
  void initState() {
    _initializeController();
    _initializeEditorHandler();
    super.initState();
  }

  void _initializeController() {
    if (widget.exerciseList != null) {
      _exerciseListController = ExerciseListController.existingList(widget.exerciseList);
    } else {
      _exerciseListController = ExerciseListController.newList();
    }
    _exerciseListController.readOnly = widget.readOnly;
  }

  void _initializeEditorHandler() {
    _exerciseEditorActionsHandler = ExerciseEditorActionsHandler(_exerciseListController);
  }

  void _startTest() {

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
                onCopyTestPressed: (BuildContext context) => _exerciseEditorActionsHandler.copyList(context),
              )];
            } else {
              return <Widget>[
                _EditableSliverAppBar(
                  definitionValueNotifier: _exerciseListController.definitionValueNotifier,
                  termValueNotifier: _exerciseListController.termValueNotifier,
                  onSaveTestPressed: (BuildContext context) => _exerciseEditorActionsHandler.saveList(context),
                  titleTextController: _exerciseListController.titleTextController,
                  termOptions: _exerciseListController.termsProvider.all(),
                  definitionOptions: _exerciseListController.definitionsProvider.all(),
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

