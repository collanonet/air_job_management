import 'package:air_job_management/models/company.dart';
import 'package:air_job_management/pages/company/widgets/company_card.dart';
import 'package:air_job_management/pages/company/widgets/filter_company.dart';
import 'package:air_job_management/pages/company/widgets/sign_up_or_delete.dart';
import 'package:air_job_management/providers/company.dart';
import 'package:air_job_management/utils/mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/japanese_text.dart';
import '../../utils/style.dart';
import '../../widgets/empty_data.dart';
import '../../widgets/loading.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> with AfterBuildMixin {
  late CompanyProvider companyProvider;

  @override
  void initState() {
    Provider.of<CompanyProvider>(context, listen: false).onInit();
    super.initState();
  }

  @override
  void afterBuild(BuildContext context) {
    getData();
  }

  getData() async {
    await companyProvider.getAllCompany();
    companyProvider.onChangeLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    companyProvider = Provider.of<CompanyProvider>(context);
    return SizedBox(
      width: AppSize.getDeviceWidth(context),
      height: AppSize.getDeviceHeight(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CompanyFilterDataWidget(),
            SignUpOrDeleteWidget(
              context2: context,
            ),
            Expanded(
                child: Container(
              decoration: boxDecoration,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "求人企業一覧",
                          style: titleStyle,
                        ),
                        IconButton(
                            onPressed: () async {
                              companyProvider.onChangeLoading(true);
                              getData();
                            },
                            icon: const Icon(Icons.refresh))
                      ],
                    ),
                    AppSize.spaceHeight16,
                    //Title
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: Text(
                            JapaneseText.company,
                            style: normalTextStyle.copyWith(fontSize: 13),
                          )),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text(JapaneseText.area, style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(JapaneseText.industry, style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 3,
                        ),
                        Expanded(
                          child: Text(JapaneseText.numberOfJobOpening, style: normalTextStyle.copyWith(fontSize: 13)),
                          flex: 3,
                        ),
                        Expanded(
                          child: Center(child: Text(JapaneseText.message, style: normalTextStyle.copyWith(fontSize: 13))),
                          flex: 3,
                        ),
                        Expanded(
                          child: Center(child: Text(JapaneseText.correspondenceStatus, style: normalTextStyle.copyWith(fontSize: 13))),
                          flex: 3,
                        )
                      ],
                    ),
                    AppSize.spaceHeight16,
                    Expanded(child: buildList())
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  buildList() {
    if (companyProvider.isLoading) {
      return Center(
        child: LoadingWidget(AppColor.primaryColor),
      );
    } else {
      if (companyProvider.companyList.isNotEmpty) {
        return ListView.separated(
            itemCount: companyProvider.companyList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
                Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == companyProvider.companyList.length ? 20 : 0)),
            itemBuilder: (context, index) {
              Company company = companyProvider.companyList[index];
              return CompanyCardWidget(company: company);
            });
      } else {
        return const Center(
          child: EmptyDataWidget(),
        );
      }
    }
  }
}
