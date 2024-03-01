import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/style.dart';
import '../../../widgets/custom_back_button.dart';

class WithDrawProcedures extends StatefulWidget {
  const WithDrawProcedures({Key? key}) : super(key: key);

  @override
  State<WithDrawProcedures> createState() => _WithDrawProceduresState();
}

class _WithDrawProceduresState extends State<WithDrawProcedures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPageColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        leadingWidth: 100,
        title: const Text('取扱職種の範囲'),
        leading: const CustomBackButtonWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
            width: AppSize.getDeviceWidth(context),
            decoration: boxDecoration,
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "求人・求職者の皆さまへ \n\nケアサービスネット株式会社 \n\n取扱職種の範囲等 \n\n■取り扱うべき職種の範囲その他の業務の範囲 当社の取扱業務範囲は、全職種（港湾運送業務、建設業務を除く） です。 当社の取扱地域は、国内 です。 \n\n■手数料に関する事項 ＜求職者から徴収する手数料＞ \n・手数料は一切申し受けません。 ＜求人者から徴収する手数料＞ \n・求職受付の際、ご負担いただく手数料は一切ございません。 \n・職業紹介を行った場合は、成功報酬として当該求職者の１年間の賃金の３５ ％（または５０万円）の うちいずれか高額な金額を限度とする紹介手数料を求人者より申し受けます。 \n\n■求人者情報の取扱いに関する事項 求人者情報の取扱者は、職業紹介責任者\n※です。 求人者の情報は、職業紹介事業に係るものに限ります。 \n\n■個人情報の取扱いに関する事項 個人情報の取扱者は、職業紹介責任者\n※です。 取扱者は、個人情報に関して当該情報の本人から情報の開示請求があった場合、本人の資格や職業経験など客観的事実に基づく情報の開示を遅滞なく行います。さらに、これに基づき訂正請求があった場合、 当該請求が客観的事実に合致するときは、遅滞なく訂正します。 \n\n■苦情処理に関する事項 苦情処理の責任者は、職業紹介責任者\n※です。 苦情の申出があった場合は、誠意を持って対応致します。 \n\n■返戻金制度に関する事項 当社は返戻金制度を設けております。返戻条件等の詳細については、契約書の該当条項をご確認下さい。\n※求人者情報の取扱者、個人情報の取扱者及び苦情処理の責任者は、厚生労働省大臣に届出を行なっている職業紹介責任者です。 その他、当事業所の業務についてご不明な点は、係員にお尋ねください。 以上",
                    style: kNormalText.copyWith(fontSize: 16, fontFamily: "Normal", color: AppColor.darkGrey)),
              ),
            )),
      ),
    );
  }
}
