import 'package:air_job_management/models/user.dart';

class EntryCalendarByUserList {
  DateTime date;
  List<EntryCalendarByUser>? list;

  EntryCalendarByUserList({required this.date, this.list});
}

class EntryCalendarByUser {
  DateTime date;
  String? userName;
  String? nonStatutoryOvertime;
  String? totalOvertime;
  String? holidayWork;
  String? withinLegal;
  String? workingHour;
  MyUser? myUser;
  String? entryId;

  EntryCalendarByUser(
      {required this.date,
      this.userName = "",
      this.myUser,
      this.entryId,
      this.nonStatutoryOvertime = "",
      this.totalOvertime = "",
      this.holidayWork = "",
      this.withinLegal = "",
      this.workingHour = ""});
}
