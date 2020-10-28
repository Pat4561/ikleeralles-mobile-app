import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {

  static const String appNameWithUrl = "Ikleeralles.nl";
  static const String appName = "Ikleeralles";

}

class Fonts {

  static const String justAnotherHand = "JustAnotherHand";
  static const String montserrat = "Montserrat";
  static const String ubuntu = "Ubuntu";

}

class BrandColors {

  static Color themeColor = Color.fromRGBO(31, 156, 238, 1);
  static Color primaryButtonColor = Color.fromRGBO(155, 197, 61, 1);
  static Color secondaryButtonColor = Color.fromRGBO(252, 114, 52, 1);
  static Color iconColorRed = Color.fromRGBO(201, 0, 0, 1);
  static Color iconColorYellow = Color.fromRGBO(249, 206, 62, 1);
  static Color iconColorGreen = Color.fromRGBO(25, 180, 56, 1);
  static Color borderColor = Color.fromRGBO(210, 210, 210, 1);
  static Color inputBorderColor = Color.fromRGBO(146, 142, 142, 1);
  static Color inputFocusedColor = Color.fromRGBO(255, 255, 255, 1);
  static Color inputErrorColor = Color.fromRGBO(210, 100, 100, 1);
  static Color labelColorYellow = Color.fromRGBO(251, 220, 20, 1);
  static Color textColorLighter = Color.fromRGBO(104, 104, 104, 1);
  static Color badgeTextColor = Color.fromRGBO(138, 135, 135, 1);
  static Color badgeBackgroundColor = Color.fromRGBO(232, 232, 232, 1);
  static Color lightGreyBackgroundColor = Color.fromRGBO(232, 232, 232, 1);
  static Color checkboxColor = Color.fromRGBO(112, 112, 112, 1);
  static Color checkboxSelectedColor = Color.fromRGBO(252, 114, 52, 1);
}

class TranslationKeys {

  static const String usernameOrEmail = "usernameOrEmail";
  static const String usernameHint = "usernameHint";
  static const String password = "password";
  static const String forgotPassword = "forgotPassword";
  static const String signIn = "signIn";
  static const String createAnAccount = "createAnAccount";
  static const String emptyTextError = "emptyTextError";
  static const String register = "register";
  static const String okay = "okay";
  static const String emailSent = "emailSent";
  static const String recoverEmailSentMessage = "recoverEmailSentMessage";
  static const String loginError = "loginError";
  static const String registrationError = "registrationError";
  static const String loadingInProgress = "loadingInProgress";
  static const String itemsBadge = "itemsBadge";
  static const String myLists = "myLists";
  static const String trashCan = "trashCan";
  static const String myFolders = "myFolders";
  static const String publicLists = "publicLists";
  static const String publicListsDescription = "publicListsDescription";
  static const String selectAll = "selectAll";
  static const String unSelectAll = "unSelectAll";
  static const String selectedLists = "selectedLists";
  static const String busyLoading = "busyLoading";
  static const String error = "error";
  static const String errorSubTitle = "errorSubTitle";
  static const String noResults = "noResults";
  static const String noResultsSubTitle = "noResultsSubTitle";
  static const String delete = "delete";
  static const String recover = "recover";
  static const String newFolder = "newFolder";
  static const String searchHint = "searchHint";
  static const String year = "year";
  static const String level = "level";
  static const String folderDeleteError = "folderDeleteError";
  static const String restoreError = "restoreError";
  static const String cancel = "cancel";
  static const String create = "create";
  static const String folderCreatePlaceholder = "folderCreatePlaceholder";
  static const String folderCreateTitle = "folderCreateTitle";
  static const String folderCreateError = "folderCreateError";
  static const String busyProcessing = "busyProcessing";
  static const String successMerged = "successMerged";
  static const String itemsAddedToFolderSuccess = "itemsAddedToFolderSuccess";
  static const String newMergedListName = "newMergedListName";
  static const String save = "save";
  static const String copy = "copy";
  static const String definition = "definition";
  static const String term = "term";
  static const String title = "title";
  static const String addSets = "addSets";
  static const String addField = "addField";
  static const String copyOfTitle = "copyOfTitle";
  static const String failedListSaved = "failedListSaved";
  static const String successListSaved = "successListSaved";
  static const String failedListCopy = "failedListCopy";
  static const String errorLoadingList = "errorLoadingList";
  static const String ignoreChanges = "ignoreChanges";
  static const String unSavedChanges = "unSavedChanges";
  static const String unSavedChangesDescription = "unSavedChangesDescription";
  static const String translateAutomatically = "translateAutomatically";
  static const String mixed = "mixed";
  static const String advancedSettings = "advancedSettings";
  static const String continueTillSuccess = "continueTillSuccess";
  static const String correctCapitals = "correctCapitals";
  static const String correctAccents = "correctAccents";
  static const String showFirstLetter = "showFirstLetter";
  static const String showVowels = "showVowels";
  static const String quizSelection = "quizSelection";
  static const String quizTimeOptions = "quizTimeOptions";
  static const String enterToNextAnswer = "enterToNextAnswer";
  static const String quizSettings = "quizSettings";
  static const String startQuiz = "startQuiz";
  static const String termToDefinition = "termToDefinition";
  static const String definitionToTerm = "definitionToTerm";
  static const String bothDirections = "bothDirections";
  static const String quizTypeInMind = "quizTypeInMind";
  static const String quizTypeTest = "quizTypeTest";
  static const String timeCorrectAnswer = "timeCorrectAnswer";
  static const String timeIncorrectAnswer = "timeIncorrectAnswer";
  static const String showMore = "showMore";
  static const String combinedQuiz = "combinedQuiz";
  static const String answer = "answer";
  static const String correct = "correct";
  static const String incorrect = "incorrect";
  static const String checkAnswer = "checkAnswer";
  static const String upcoming = "upcoming";
  static const String errors = "errors";
  static const String asked = "asked";
  static const String markPreviousAnswerCorrect = "markPreviousAnswerCorrect";
  static const String showHint = "showHint";
}

class WebUrls {
  static const String register = "https://www.ikleeralles.nl/aanmelden";
  static const String forgotPassword = "https://www.ikleeralles.nl/requestpassword";
}

class AssetPaths {
  static const String internet = 'assets/svg/internet.svg';
  static const String rootDirectory = 'assets/svg/root_directory.svg';
  static const String trash = 'assets/svg/trash.svg';
  static const String trashSolid = 'assets/svg/trash_solid.svg';
  static const String add = 'assets/svg/add.svg';
  static const String start = 'assets/svg/start.svg';
  static const String merge = 'assets/svg/merge.svg';
  static const String move = 'assets/svg/move.svg';
}