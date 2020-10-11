import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/network/models/exercise_list.dart';
import 'package:ikleeralles/ui/bottomsheets/options.dart';
import 'package:ikleeralles/ui/exercise_controller.dart';
import 'package:ikleeralles/ui/tables/exercise_editor.dart';
import 'package:ikleeralles/ui/themed/button.dart';
import 'package:ikleeralles/ui/themed/select.dart';
import 'package:ikleeralles/ui/themed/textfield.dart';
import 'package:scoped_model/scoped_model.dart';


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

class ExerciseEditorPage extends StatefulWidget {

  final ExerciseList exerciseList;

  ExerciseEditorPage ({ this.exerciseList });

  @override
  State<StatefulWidget> createState() {
    return _ExerciseEditorPageState();
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

