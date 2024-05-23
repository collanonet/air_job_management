class AttendanceManagement {
  String? username;
  String? userId;
  String? typeOfWork;
  String? numberOfActualWorkDay;
  String? numberOfWorkDay;
  String? paidHoliday;
  String? remainingNumberOfPaidHoliday;
  String? publicHoliday;
  String? specialLeave;
  String? numberOfDayTransferred;
  String? numberOfHolidayWork;
  String? numberOfAbsence;
  String? numberOfLateTime;
  String? numberOfLeaveEarly;
  String? unpaidTime;
  String? withinStatutoryOvertime;
  String? nonStatutoryOvertime;
  String? standardOvertime;
  String? totalOvertime;
  String? midnightWork;
  String? numberOfHolidayWorkTime;
  String? totalActualWorkTime;
  String? totalWorkTime;
  String? totalOvertimeWorkingHours;
  AttendanceManagement(
      {this.specialLeave,
      this.publicHoliday,
      this.nonStatutoryOvertime,
      this.totalOvertime,
      this.userId,
      this.username,
      this.midnightWork,
      this.numberOfAbsence,
      this.numberOfActualWorkDay,
      this.numberOfDayTransferred,
      this.numberOfHolidayWork,
      this.numberOfHolidayWorkTime,
      this.numberOfLateTime,
      this.numberOfLeaveEarly,
      this.numberOfWorkDay,
      this.paidHoliday,
      this.remainingNumberOfPaidHoliday,
      this.standardOvertime,
      this.totalActualWorkTime,
      this.totalOvertimeWorkingHours,
      this.totalWorkTime,
      this.typeOfWork,
      this.unpaidTime,
      this.withinStatutoryOvertime});
}
