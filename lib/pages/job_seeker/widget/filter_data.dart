import 'package:air_job_management/providers/job_seeker.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobSeekerFilterDataWidget extends StatelessWidget {
  const JobSeekerFilterDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<JobSeekerProvider>(context);
    return Container(
      width: AppSize.getDeviceWidth(context),
      height: 140,
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            JapaneseText.applicantSearch,
            style: titleStyle,
          ),
          AppSize.spaceHeight16,
          Row(
            children: [
              //Left
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    JapaneseText.correspondenceStatus,
                    style: normalTextStyle,
                  ),
                  AppSize.spaceHeight8,
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: InputDecorator(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                          )),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: provider.selectedStatus,
                            items: provider.statusList
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: provider.onChangeStatus),
                      ),
                    ),
                  ),
                ],
              ),
              AppSize.spaceWidth16,
              //Right
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    JapaneseText.newArrivalOrInterview,
                    style: normalTextStyle,
                  ),
                  AppSize.spaceHeight8,
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: InputDecorator(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                          )),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: provider.selectedNewArrival,
                            items: provider.newArrivalList
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: provider.onChangeNewArrival),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
