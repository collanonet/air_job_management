import 'package:air_job_management/providers/job_posting.dart';
import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/utils/date_time_utils.dart';
import 'package:flutter/material.dart';

class FilterDateCard extends StatelessWidget {
  final JobPostingProvider provider;
  final bool isStartDate;
  const FilterDateCard({Key? key, required this.provider, required this.isStartDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    return InkWell(
      onTap: () async {
        var date = await showDatePicker(
            locale: const Locale("ja", "JP"),
            context: context,
            initialDate: isStartDate ? (provider.startDateForFilter ?? now) : (provider.endDateForFilter ?? now),
            firstDate: now.subtract(const Duration(days: 3000)),
            lastDate: now.add(const Duration(days: 3000)));
        if (date != null) {
          if (isStartDate) {
            provider.onChangeStartDate(date);
          } else {
            provider.onChangeEndDate(date);
          }
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 170,
          height: 45,
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(width: 1, color: AppColor.endColor)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isStartDate
                  ? Text(provider.startDateForFilter == null ? "" : MyDateTimeUtils.convertDateToString(provider.startDateForFilter!))
                  : Text(provider.endDateForFilter == null ? "" : MyDateTimeUtils.convertDateToString(provider.endDateForFilter!)),
              Icon(
                Icons.calendar_month_rounded,
                color: AppColor.endColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
