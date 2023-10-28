import 'package:air_job_management/pages/job_posting/widgets/filter_date_card.dart';
import 'package:air_job_management/providers/job_posting.dart';
import 'package:air_job_management/utils/app_size.dart';
import 'package:air_job_management/utils/japanese_text.dart';
import 'package:air_job_management/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobPostingFilterFilterDataWidget extends StatelessWidget {
  const JobPostingFilterFilterDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<JobPostingProvider>(context);
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
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                          )),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            value: provider.selectedStatus,
                            items: provider.statusList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: provider.onChangeStatus),
                      ),
                    ),
                  ),
                ],
              ),
              AppSize.spaceWidth16,
              //Right
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(JapaneseText.recruitmentStart, style: normalTextStyle),
                      AppSize.spaceHeight5,
                      FilterDateCard(provider: provider, isStartDate: true)
                    ],
                  ),
                  AppSize.spaceWidth16,
                  const Padding(padding: EdgeInsets.only(top: 35), child: Text("~")),
                  AppSize.spaceWidth16,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        JapaneseText.end,
                        style: normalTextStyle,
                      ),
                      AppSize.spaceHeight5,
                      FilterDateCard(provider: provider, isStartDate: false)
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
