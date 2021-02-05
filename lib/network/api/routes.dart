class Routes {

  static String register = "user";
  static String userInfo = "me";
  static String myExerciseLists = "list/me";
  static String myFolders = "folder/me";
  static String auth = "auth/login";
  static String levels = "levels";
  static String deletedExerciseLists = "list/deleted";
  static String searchExerciseLists = "list/search";
  static String folder(int folderId) => "folder/$folderId";
  static String moveExerciseList(int folderId) => "folder/$folderId/list/multiple";
  static String restoreExerciseList = "list/restore";
  static String deleteExerciseLists = "list/delete";
  static String createFolder = "folder";
  static String deleteFolder(int folderId) => "folder/$folderId/delete";
  static String createExerciseList = "list";
  static String exerciseList(int listId) => "list/$listId";
  static String translate = "translate";
  static String languages = "translate/languages";
  static String myGroups = "group/me";
  static String premiumInfo = "user/premium";
  static String syncPaymentInfo = "payment/revenuecat/sync";
  static String groupExerciseLists(int groupId) => "group/$groupId";


}