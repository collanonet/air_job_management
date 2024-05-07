import 'package:air_job_management/models/entry_exit_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_textfield.dart';

class RattingWidgetPage extends StatefulWidget {
  final EntryExitHistory entryExitHistory;
  final Function onRate;
  const RattingWidgetPage({super.key, required this.entryExitHistory, required this.onRate});

  @override
  State<RattingWidgetPage> createState() => _RattingWidgetPageState();
}

class _RattingWidgetPageState extends State<RattingWidgetPage> {
  double rate = 5;
  TextEditingController controller = TextEditingController(text: "");

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.entryExitHistory.review != null) {
      rate = double.parse(widget.entryExitHistory.review!.rate!);
      controller.text = widget.entryExitHistory.review?.comment ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Title(
          color: AppColor.secondaryColor,
          child: Text(
            "この仕事を評価する",
            style: kTitleText,
          )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: rate,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              rate = rating;
            },
          ),
          AppSize.spaceHeight8,
          PrimaryTextField(
            controller: controller,
            hint: "フィードバックをお寄せください",
            isRequired: false,
            maxLine: 5,
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "いいえ",
            )),
        TextButton(
            onPressed: () => widget.onRate(rate, controller.text),
            child: const Text(
              "はい",
            )),
      ],
    );
  }
}
