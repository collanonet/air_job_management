class LateTimeHelper {
  static int lateTimeToMinute(String selectedLateTime){
    if(selectedLateTime == "アラーム設定: 05分以上"){
      return 5;
    }else if(selectedLateTime == "アラーム設定: 10分以上"){
      return 10;
    }else if(selectedLateTime == "アラーム設定: 15分以上"){
      return 15;
    }else if(selectedLateTime == "アラーム設定: 20分以上"){
      return 20;
    }else if(selectedLateTime == "アラーム設定: 25分以上"){
      return 25;
    }else if(selectedLateTime == "アラーム設定: 30分以上"){
      return 30;
    }else if(selectedLateTime == "アラーム設定: 45分以上"){
      return 45;
    }else if(selectedLateTime == "アラーム設定: 1時間以上"){
      return 60;
    }else if(selectedLateTime == "アラーム設定: 1時間30分以上"){
      return 90;
    }
    return 120;
  }

  static String checkingLength(String value){
    if(value.length > 1){
      return value;
    }else{
      return "0$value";
    }
  }
}