class EntryCalendarByUser {
  DateTime date;
  String? userName;
  String? nonStatutoryOvertime;
  String? totalOvertime;
  String? holidayWork;
  String? withinLegal;
  String? workingHour;

  EntryCalendarByUser(
      {required this.date,
      this.userName = "",
      this.nonStatutoryOvertime = "",
      this.totalOvertime = "",
      this.holidayWork = "",
      this.withinLegal = "",
      this.workingHour = ""});
}
