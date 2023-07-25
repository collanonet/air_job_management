import '../helper/date_to_api.dart';

List<int> calculateOvertime2(startWorkTime, userExitWork, breakTime) {
  if (userExitWork == null || userExitWork == "") {
    userExitWork = "00:00";
  }

  if (breakTime == null || breakTime == "") {
    breakTime = "00:00";
  }

  var breakMinutes = int.parse(breakTime.split(":")[1]);
  var breakHours = int.parse(breakTime.split(":")[0]);

  //Convert to 2 digits
  String firstStartWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(startWorkTime.split(":").first);
  String secondStartWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(startWorkTime.split(":").last);
  startWorkTime = "$firstStartWorkTime:$secondStartWorkTime";
  String firstEndWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(userExitWork.split(":").first);
  String secondEndWorkTime =
      DateToAPIHelper.formatTimeTwoDigits(userExitWork.split(":").last);
  userExitWork = "$firstEndWorkTime:$secondEndWorkTime";
  // Convert the start and end work times to DateTime objects
  var startDateTime = DateTime.parse("2023-04-04 $startWorkTime");
  var endDateTime = DateTime.parse("2023-04-04 $userExitWork");

  // Calculate the difference between the start and end DateTime objects
  var difference = endDateTime.difference(startDateTime);

  // Get the number of hours in the difference
  var hours = difference.inHours;

  // Get the number of minutes in the difference
  var minutes = difference.inMinutes % 60;

  // Calculate the overtime hours
  var overtimeHours = hours - 8 - breakHours;
  print("Hours $hours $startDateTime $endDateTime");
  print("breakHours $breakHours");
  print("Overtime hour $overtimeHours");

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
  print("2 breakHours $breakHours");
  print("2 Overtime hour $overtimeHours");

  if (overtimeHours < 0) {
    overtimeHours = 0;
  }
  return [overtimeHours, minutes];
}
