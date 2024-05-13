import 'package:air_job_management/models/user.dart';

class EntryExitCalendarByUser {
  String? userName;
  List<EntryCalendarByUserDate> list;
  EntryExitCalendarByUser({required this.userName, required this.list});
}

class EntryCalendarByUserDate {
  DateTime date;
  Entry? entry;

  EntryCalendarByUserDate({required this.date, this.entry});
}

class Entry {
  String? userName;
  String? nonStatutoryOvertime;
  String? totalOvertime;
  String? holidayWork;
  String? withinLegal;
  String? workingHour;
  MyUser? myUser;
  String? entryId;

  Entry(
      {this.userName = "",
      this.myUser,
      this.entryId,
      this.nonStatutoryOvertime = "",
      this.totalOvertime = "",
      this.holidayWork = "",
      this.withinLegal = "",
      this.workingHour = ""});
}
