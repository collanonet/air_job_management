import 'package:air_job_management/utils/japanese_text.dart';

class MyUser {
  String? uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? username;
  final String? photoURL;
  final String? address2;
  final String? sex;
  final String? tel1;
  final String? tel2;
  String? workgroup;
  final String? workAddress;
  final String? shiftType;
  final String? type;
  final String? startWorkTime;
  final String? endWorkTime;
  final List<dynamic>? salaryID;
  final String? entryExitID;
  final bool? isWorking;
  final int? breakTime;
  final String? gender;
  final String? appId;
  final String? employmentDate;
  final String? resignDate;
  final int? totalWorkingHourPerWeek;
  final int? numberOfWorkingDay;
  final String? workType;
  final String? dob;
  String? holiday;
  final String? staffNumber;
  final String? shiftTemplateName;
  final String? role;
  final String? country;
  final String? nationality;
  final String? startDate;
  final String? startDateOfSalary;
  List<String>? workGroupString;
  String? workingRuleName;
  String? workingRuleId;
  String? hashPassword;
  String? totalHourPerWeek;
  String? transportationFee;
  String? jobType;
  String? payrollDay;
  String? workStyle;
  String? workStyleTime;
  String? notificationToken;
  List<HolidayManagement> holidayManagement;
  String? paidHolidaySetting;
  String? holidayWorkSetting;
  String? compensationSetting;
  MyUser(
      {this.gender,
      this.workAddress,
      this.breakTime,
      this.entryExitID,
      this.isWorking,
      this.salaryID,
      this.startWorkTime,
      this.endWorkTime,
      this.shiftType,
      this.username,
      this.photoURL,
      this.email,
      this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.sex,
      this.tel1,
      this.tel2,
      this.workgroup,
      this.appId,
      this.type,
      this.totalWorkingHourPerWeek,
      this.employmentDate,
      this.numberOfWorkingDay,
      this.resignDate,
      this.workType,
      this.dob,
      this.holiday,
      this.staffNumber,
      this.shiftTemplateName,
      this.uid,
      this.role,
      this.nationality,
      this.startDate,
      this.startDateOfSalary,
      this.country,
      this.workGroupString,
      this.workingRuleName,
      this.workingRuleId,
      this.hashPassword,
      this.totalHourPerWeek,
      this.transportationFee,
      this.jobType,
      this.payrollDay,
      this.workStyle,
      this.workStyleTime,
      this.notificationToken,
      required this.holidayManagement,
      this.compensationSetting,
      this.holidayWorkSetting,
      this.paidHolidaySetting});

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
        compensationSetting: json["compensatory_setting"] ?? "",
        holidayWorkSetting: json["holiday_work_setting"] ?? "",
        paidHolidaySetting: json["paid_holiday_setting"] ?? "",
        notificationToken: json["notification_token"] ?? "",
        payrollDay: json["payroll_day"] ?? "30",
        transportationFee: json["transportation_fee"] == null
            ? "0"
            : json["transportation_fee"] == ""
                ? "0"
                : json["transportation_fee"],
        jobType: json["job_type"],
        workStyle: json["work_style"] ?? JapaneseText.normalWorkStyle,
        workStyleTime: json["work_style_time"] ?? "08:00",
        hashPassword: json["hash_password"],
        workingRuleName: json["working_rule_name"],
        workingRuleId: json["working_rule_id"],
        nationality: json["nationality"],
        type: json["type"],
        startDate: json["start_date"],
        startDateOfSalary: json["start_date_salary"],
        country: json["country"],
        role: json["role"],
        shiftTemplateName: json["shift_template"],
        email: json["email"] ?? "",
        workgroup: json["workgroup"],
        gender: json["gender"],
        breakTime: json["break_time"],
        address1: json["address1"],
        address2: json["address2"],
        appId: json["app_id"],
        endWorkTime: json["end_work_time"],
        startWorkTime: json["start_work_time"],
        entryExitID: json["entry_exit_id"],
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        isWorking: json["is_working"],
        photoURL: json["image_url"],
        salaryID: json["salary_id"] != null ? List<String>.from(json["salary_id"].map((x) => x)) : [],
        sex: json["sex"],
        shiftType: json["shift_type"],
        tel1: json["tel1"],
        tel2: json["tel2"],
        username: json["username"],
        workAddress: json["work_address"],
        dob: json["dob"],
        employmentDate: json["employment_date"],
        holiday: json["paid_holidays"] != null ? json["paid_holidays"].toString() : "0",
        numberOfWorkingDay: json["number_of_working_day"],
        resignDate: json["resign_date"],
        staffNumber: json["staff_number"],
        totalWorkingHourPerWeek: json["work_hour_per_week"],
        workType: json["work_type"],
        holidayManagement: json["holiday_management"] != null
            ? List<HolidayManagement>.from(json["holiday_management"].map((x) => HolidayManagement.fromJson(x)))
            : []);
  }
}

class HolidayManagement {
  String name;
  String id;
  String date;
  num day;
  DateTime dateTime;
  DateTime grantDate;
  DateTime deadline;
  bool addNew;

  HolidayManagement(
      {required this.dateTime,
      required this.name,
      required this.date,
      required this.deadline,
      required this.grantDate,
      required this.day,
      required this.id,
      this.addNew = false});

  factory HolidayManagement.fromJson(Map<String, dynamic> json) {
    return HolidayManagement(
        id: json["id"],
        day: json["day"],
        name: json["name"],
        date: json["date"],
        dateTime: json["date_time"].toDate(),
        grantDate: json["grant_date"].toDate(),
        deadline: json["deadline"].toDate());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "name": name,
        "date": date,
        "date_time": dateTime,
        "grant_date": grantDate,
        "deadline": deadline,
      };
}
