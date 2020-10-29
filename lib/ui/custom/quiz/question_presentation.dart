import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:ikleeralles/constants.dart';
import 'package:ikleeralles/logic/quiz/input.dart';
import 'package:ikleeralles/logic/quiz/speech.dart';
import 'package:ikleeralles/network/api/url.dart';
import 'package:ikleeralles/ui/hyperlink.dart';
import 'package:ikleeralles/ui/snackbar.dart';

class QuizQuestionPresentation extends StatefulWidget {

  final QuizQuestion question;
  final WidgetBuilder formBuilder;
  final String hint;


  QuizQuestionPresentation (this.question, { this.hint, this.formBuilder, GlobalKey key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QuizQuestionPresentationState();
  }

}

class QuizQuestionUserResponse {

  final bool correctlyAnswered;

  QuizQuestionUserResponse ({ @required this.correctlyAnswered });

}

class QuizQuestionPresentationState extends State<QuizQuestionPresentation> {

  SpeechPlayer _speechPlayer;

  QuizQuestionUserResponse _response;

  final GlobalKey<_HintPresentationState> hintPresentationKey = GlobalKey<_HintPresentationState>();

  void showFeedback(QuizQuestionUserResponse response) {
    setState(() {
      _response = response;
    });
  }

  void restore() {
    if (hintPresentationKey.currentState != null) {
      hintPresentationKey.currentState.setVisible(false);
    }
    setState(() {
      _response = null;
    });
  }

  @override
  void initState() {
    _speechPlayer = SpeechPlayer(
      language: widget.question.language
    );
    super.initState();
  }


  void _playSound(BuildContext context) {
    _speechPlayer.play(
      widget.question.title
    ).catchError((e) {
      showToast(FlutterI18n.translate(context, TranslationKeys.errorSubTitle));
    });
  }

  Widget _titlePresentation(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(widget.question.title, style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.ubuntu,
        ))),
        Container(
          child: IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () => _playSound(context),
          ),
          margin: EdgeInsets.only(
              left: 15
          ),
        )
      ],
    );
  }

  Widget _hintPresentation(BuildContext context) {
    return Visibility(
      child: Container(
        child: _HintPresentation(
          hint: widget.hint,
          key: hintPresentationKey
        ),
        margin: EdgeInsets.only(
          top: 5
        ),
      ),
      visible: widget.hint != null,
    );
  }

  Widget _form(BuildContext context) {
    if (widget.formBuilder != null) {
      var formWidget = widget.formBuilder(context);
      if (formWidget != null) {
        return formWidget;
      }
    }
    return Container();
  }

  Widget _feedback(BuildContext context) {
    if (_response != null) {
      return Container(
        child: Text(widget.question.answers.join(", "), style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.ubuntu,
            color: _response.correctlyAnswered ? Colors.green : Colors.red
        )),
        margin: EdgeInsets.only(
          top: 20
        ),
      );
    } else {
      return Container();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titlePresentation(context),
        _hintPresentation(context),
        Visibility(
          visible: _response == null,
          child: _form(context),
        ),
        Visibility(
          visible: _response != null,
          child: _feedback(context),
        )
      ],
    );
  }

}

class _HintPresentation extends StatefulWidget {

  final String hint;

  _HintPresentation ({ @required this.hint, GlobalKey<_HintPresentationState> key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HintPresentationState();
  }

}

class _HintPresentationState extends State<_HintPresentation> {

  bool _isHintVisible = false;

  void setVisible(bool isVisible) {
    setState(() {
      _isHintVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hyperlink(
        baseColor: Colors.grey,
        highlightedColor: BrandColors.secondaryButtonColor,
        onPressed: () {
          setVisible(!_isHintVisible);
        },
        builder: (bool isSelected, Color color) {
          return Row(
            children: <Widget>[
              Icon(Icons.remove_red_eye, color: color),
              Container(
                margin: EdgeInsets.only(
                    left: 10
                ),
                child: Text(
                  _isHintVisible ? widget.hint : FlutterI18n.translate(context, TranslationKeys.showHint),
                  style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.ubuntu
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

}