class Routes {

  static String userInfo = "me";
  static String myExerciseLists = "list/me";
  static String myFolders = "folder/me";
  static String auth = "auth/login";
  static String levels = "levels";
  static String deletedExerciseLists = "list/deleted";
  static String exerciseListsByFolder(int folderId) => "folder/$folderId";

}