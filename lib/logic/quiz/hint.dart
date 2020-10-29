import 'package:ikleeralles/logic/quiz/input.dart';

class HintGenerator {

  final bool showVowels;
  final bool showFirstLetter;

  HintGenerator ({ this.showVowels = false, this.showFirstLetter = false });

  String _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  String _hint(String input) {
    String hinted = ("*" * input.length);

    if (showVowels) {
      for (int i = 0; i < input.length; i++) {
        var char = input[i];
        char = char.toLowerCase();
        if (char == " ") {
          hinted = _replaceCharAt(hinted, i, " ");
        }

        var vowels = ["a", "e", "u", "i"];
        if (vowels.contains(char)) {
          hinted = _replaceCharAt(hinted, i, char);
        }
      }
    }

    if (showFirstLetter) {
      hinted = _replaceCharAt(hinted, 0, input[0]);
    }
    return hinted;
  }

  String generate(QuizQuestion question) {
    if (!showVowels && !showFirstLetter) {
      return null;
    } else {
      return question.answers.map((val) => _hint(val)).toList().join(", ");
    }
  }

}