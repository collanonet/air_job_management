import 'package:air_job_management/utils/my_route.dart';
import 'package:air_job_management/widgets/custom_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../api/worker_api/search_api.dart';
import '../../const/const.dart';
import '../../helper/currency_format.dart';
import '../../helper/japan_date_time.dart';
import '../../models/worker_model/search_job.dart';
import '../../models/worker_model/shift.dart';
import '../../pages/register/widget/check_box.dart';
import '../../providers/auth.dart';
import '../../utils/app_color.dart';
import '../../utils/app_size.dart';
import '../../utils/style.dart';
import '../../utils/toast_message_util.dart';

class ConfirmApplyJobDialog extends StatefulWidget {
  final SearchJob info;
  final List<ShiftModel> selectedShiftList;
  const ConfirmApplyJobDialog(
      {Key? key, required this.selectedShiftList, required this.info})
      : super(key: key);

  @override
  State<ConfirmApplyJobDialog> createState() => _ConfirmApplyJobDialogState();
}

class _ConfirmApplyJobDialogState extends State<ConfirmApplyJobDialog> {
  List<ShiftModel> selectedShiftList = [];
  bool isSelect = false;
  bool isLoading = false;

  @override
  void initState() {
    selectedShiftList = widget.selectedShiftList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context);
    return CustomLoadingOverlay(
      isLoading: isLoading,
      child: AlertDialog(
        content: Container(
          width: AppSize.getDeviceWidth(context) * 0.85,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: AppSize.getDeviceWidth(context),
                      height: AppSize.getDeviceHeight(context) * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: NetworkImage(widget.info.image != null &&
                                    widget.info.image != ""
                                ? widget.info.image!
                                : ConstValue.defaultBgImage),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColor.greyColor, width: 1),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            CurrencyFormatHelper.displayData(
                                widget.info.hourlyWag),
                            style: kTitleText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColor.greyColor),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white),
                          child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                color: AppColor.primaryColor,
                              )),
                        ))
                  ],
                ),
                Center(
                  child: Text(
                    widget.info.title.toString(),
                    style: kNormalText.copyWith(
                        color: AppColor.primaryColor, fontSize: 15),
                  ),
                ),
                AppSize.spaceHeight8,
                Text(widget.info.notes.toString()),
                AppSize.spaceHeight16,
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedShiftList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xff00000010),
                                offset:
                                    Offset(0, 9), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1, color: AppColor.secondaryColor),
                            color: Color(0xffFAFFD3)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 51,
                                      height: 51,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            dateTimeToMonthDay(
                                                selectedShiftList[index].date),
                                            style: kNormalText.copyWith(
                                                fontFamily: "Bold",
                                                fontSize: 13,
                                                color: AppColor.primaryColor),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, left: 5),
                                            child: Text(
                                              toJapanWeekDayWithInt(
                                                  selectedShiftList[index]
                                                      .date!
                                                      .weekday),
                                              style: kNormalText.copyWith(
                                                  fontFamily: "Normal",
                                                  fontSize: 9,
                                                  color: AppColor.primaryColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    AppSize.spaceWidth8,
                                    Text(
                                      "${selectedShiftList[index].startWorkTime} 〜 ${selectedShiftList[index].endWorkTime}",
                                      style: kNormalText.copyWith(
                                          fontSize: 15, fontFamily: "Normal"),
                                    ),
                                    AppSize.spaceWidth8,
                                    Text(
                                      "${CurrencyFormatHelper.displayDataRightYen(selectedShiftList[index].price)}",
                                      style: kNormalText.copyWith(
                                          fontSize: 15, fontFamily: "Normal"),
                                    ),
                                  ],
                                ),
                              ),
                              AppSize.spaceWidth8,
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.green,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                AppSize.spaceHeight16,
                CheckBoxListTileWidget(
                    size: AppSize.getDeviceWidth(context),
                    title: "お仕事の内容や注意事項などすべて確認しました。",
                    val: isSelect,
                    onChange: (v) {
                      setState(() {
                        isSelect = v;
                      });
                    }),
                AppSize.spaceHeight16,
                InkWell(
                  onTap: () => onApply(auth),
                  child: Container(
                    width: AppSize.getDeviceWidth(context),
                    height: AppSize.getDeviceHeight(context) * 0.075,
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '応募する',
                        style: kNormalText.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  onApply(auth) async {
    if (isSelect) {
      setState(() {
        isLoading = true;
      });
      bool isSuccess = await SearchJobApi()
          .createJobRequest(widget.info, auth.myUser!, selectedShiftList);
      setState(() {
        isLoading = false;
      });
      if (isSuccess) {
        Navigator.pop(context);
        context.go(MyRoute.successApplyJob);
      } else {
        toastMessageError(errorMessage, context);
      }
    } else {
      toastMessageError("チェックボックスをオンにしてください", context);
    }
  }
}
