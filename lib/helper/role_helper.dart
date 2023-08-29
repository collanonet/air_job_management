class RoleHelper {
  static String staff = "worker";
  static String subManager = "sub-manager";
  static String admin = "admin";
  static String staffJP = "スタッフ";
  static String subManagerJP = "勤怠管理者";
  static String adminJP = "システム管理者";

  static String roleFromApi(String value) {
    if (value == staff) {
      return staffJP;
    } else if (value == subManager) {
      return subManagerJP;
    } else {
      return adminJP;
    }
  }

  static String roleToApi(String value) {
    if (value == staffJP) {
      return staff;
    } else if (value == subManagerJP) {
      return subManager;
    } else {
      return admin;
    }
  }
}
