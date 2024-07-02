import '../helper/date_to_api.dart';

int overTimeLegalLimit = 8;

List<int> calculateWorkingTime(startWork, exitWork, breakTime) {
  if (exitWork == "") {
    exitWork = "00:00";
  }
  breakTime ??= "00:00";
  startWork ??= "00:00";
  exitWork ??= "00:00";
  if (startWork == ":") {
    startWork = "00:00";
  }
  if (exitWork == ":") {
    exitWork = "00:00";
  }
  if (breakTime == ":") {
    breakTime = "00:00";
  }
  int startWorkHour = int.parse(startWork.split(':')[0]);
  int startWorkMinute = int.parse(startWork.split(':')[1]);
  int exitWorkHour = int.parse(exitWork.split(':')[0]);
  int exitWorkMinute = int.parse(exitWork.split(':')[1]);
  int breakTimeHour = int.parse(breakTime.split(':')[0]);
  int breakTimeMinute = int.parse(breakTime.split(':')[1]);
  int workHour = 0;
  int workMinute = 0;

  ///Over a day
  if (startWorkHour > exitWorkHour) {
    exitWorkHour += 24;
  }
  workHour = exitWorkHour - startWorkHour;
  if (workHour >= 0) {
    if (exitWorkMinute >= startWorkMinute) {
      workMinute = exitWorkMinute - startWorkMinute;
    } else {
      if (workHour > 0) {
        workMinute = (exitWorkMinute + 60) - startWorkMinute;
        workHour = workHour - 1;
      } else {
        workHour = 0;
        workMinute = 0;
      }
    }
  } else {
    if (exitWorkMinute >= startWorkMinute) {
      workMinute = exitWorkMinute - startWorkMinute;
    }
  }
  if (breakTimeHour > 0) {
    workHour = workHour - breakTimeHour;
  }
  if (workMinute >= breakTimeMinute) {
    workMinute = workMinute - breakTimeMinute;
  } else {
    workMinute = (workMinute + 60) - breakTimeMinute;
    workHour = workHour - 1;
  }
  //Check if work hour or minute
  if (workHour < 0) {
    workHour = 0;
  }
  if (workMinute < 0) {
    workMinute = 0;
  }
  return [workHour, workMinute];
}

List<int> calculateOvertime(scheduleEndWorkTime, userExitWork, breakTime) {
  if (scheduleEndWorkTime == null ||
      scheduleEndWorkTime == "" ||
      scheduleEndWorkTime == "null") {
    scheduleEndWorkTime = "00:00";
  }

  if (userExitWork == null || userExitWork == "" || userExitWork == "null") {
    userExitWork = "00:00";
  }

  if (breakTime == null || breakTime == "" || breakTime == "null") {
    breakTime = "00:00";
  }

  var breakMinutes = int.parse(breakTime.split(":")[1]);
  var breakHours = int.parse(breakTime.split(":")[0]);

  //Convert to 2 digits
  String firstStartWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(scheduleEndWorkTime.split(":").first);
  String secondStartWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(scheduleEndWorkTime.split(":").last);
  scheduleEndWorkTime = "$firstStartWorkTime:$secondStartWorkTime";
  String firstEndWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(userExitWork.split(":").first);
  String secondEndWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(userExitWork.split(":").last);
  userExitWork = "$firstEndWorkTime:$secondEndWorkTime";
  // Convert the start and end work times to DateTime objects
  var startDateTime = DateTime.parse("2023-04-04 $scheduleEndWorkTime");
  var endDateTime = DateTime.parse("2023-04-04 $userExitWork");

  // Calculate the difference between the start and end DateTime objects
  var difference = endDateTime.difference(startDateTime);

  // Get the number of hours in the difference
  var hours = difference.inHours;

  // Get the number of minutes in the difference
  var minutes = difference.inMinutes % 60;

  print("Hour ${difference.inHours}, Min ${difference.inMinutes}");

  if (difference.inHours < 0 || difference.inMinutes < 0) {
    return [0, 0];
  }

  // Calculate the overtime hours
  var overtimeHours = hours - breakHours;

  if (hours > 8) {
    overtimeHours = hours - 8 - breakHours;
  } else {
    overtimeHours = hours - breakHours;
  }

  if (breakMinutes > 0) {
    if (breakMinutes > minutes) {
      if (overtimeHours > 0) {
        overtimeHours = overtimeHours - 1;
        minutes = minutes + 60;
        minutes = minutes - breakMinutes;
      } else {
        overtimeHours = 0;
        minutes = 0;
      }
    } else {
      minutes = minutes - breakMinutes;
    }
  }

  if (overtimeHours < 0) {
    overtimeHours = 0;
  }
  return [overtimeHours, minutes];
}

List<int> calculateBreakTime(now, startBreakTime) {
  if (startBreakTime == null ||
      startBreakTime == "" ||
      startBreakTime == "null" ||
      startBreakTime == ":") {
    startBreakTime = "00:00";
  }

  if (now == null || now == "" || now == "null" || now == ":") {
    now = "00:00";
  }
  int startBreakTimeHour = int.parse(startBreakTime.split(':')[0]);
  int startBreakTimeMinute = int.parse(startBreakTime.split(':')[1]);
  int nowHour = int.parse(now.split(':')[0]);
  int nowMinute = int.parse(now.split(':')[1]);
  int breakTimeHour = 0;
  int breakTimeMinute = 0;
  if (nowHour >= startBreakTimeHour) {
    breakTimeHour = nowHour - startBreakTimeHour;
    if (nowMinute >= startBreakTimeMinute) {
      breakTimeMinute = nowMinute - startBreakTimeMinute;
    } else {
      if (breakTimeHour > 0) {
        breakTimeMinute = (nowMinute + 60) - startBreakTimeMinute;
        breakTimeHour = breakTimeHour - 1;
      } else {
        breakTimeHour = 0;
        breakTimeMinute = 0;
      }
    }
  }
  return [breakTimeHour, breakTimeMinute];
}

List<int> calculateLateTime(scheduleStartWorkTime, now) {
  int lateHrs = 0;
  int lateMinute = 0;
  int currentHour = int.parse(now.split(':')[0]);
  int currentMinute = int.parse(now.split(':')[1]);
  int userStartWorkHr = int.parse(scheduleStartWorkTime.split(':')[0]);
  int userStartWorkMinute = int.parse(scheduleStartWorkTime.split(':')[1]);
  if (scheduleStartWorkTime.toString().isNotEmpty) {
    if (userStartWorkHr > currentHour) {
      currentHour = currentHour + 24;
    }
    lateHrs = currentHour - userStartWorkHr;
    if (lateHrs >= 0) {
      if (currentMinute >= userStartWorkMinute) {
        lateMinute = currentMinute - userStartWorkMinute;
      } else {
        if (lateHrs > 0) {
          lateMinute = (currentMinute + 60) - userStartWorkMinute;
          lateHrs = lateHrs - 1;
        } else {
          lateHrs = 0;
          lateMinute = 0;
        }
      }
    } else {
      lateHrs = 0;
      lateMinute = 0;
    }
  }
  return [lateHrs, lateMinute];
}
