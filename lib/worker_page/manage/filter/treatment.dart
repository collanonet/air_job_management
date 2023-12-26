import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/custom_button.dart';

class Treatment extends StatefulWidget {
  const Treatment({super.key});

  @override
  State<Treatment> createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  int _selectedIndex = 0;
  List<String> data = [
    '未経験歓迎',
    'まかないあり',
    '服装自由',
    '髪型/ヘアカラー自由',
    '交通費支給',
    'バイク/車通勤可',
    '自転車通勤可',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('時間帯')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 10 / 18,
                    mainAxisExtent: 60,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                itemBuilder: (context, index) {
                  var item = data[index];
                  return Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color:
                          index == _selectedIndex ? Colors.amber : Colors.white,
                      border: Border.all(
                        color: AppColor.darkBlueColor,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      title: Text(item),
                      selected: index == _selectedIndex,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            ButtonWidget(
              color: AppColor.primaryColor,
              title: 'OK',
              onPress: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget builbox(var item, int index) {
    return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        color: index == _selectedIndex ? Colors.amber : Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: ListTile(
        title: Text(item),
        selected: index == _selectedIndex,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
