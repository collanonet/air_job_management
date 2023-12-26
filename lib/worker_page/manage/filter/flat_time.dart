import 'package:air_job_management/utils/app_color.dart';
import 'package:air_job_management/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FlatTime extends StatefulWidget {
  const FlatTime({super.key});

  @override
  State<FlatTime> createState() => _FlatTimeState();
}

class _FlatTimeState extends State<FlatTime> {
  int _selectedIndex = 0;
  List<String> data = [
    '午前中',
    '12時−14時',
    '14時−16時',
    '16時−18時',
    '18時−20時',
    '20時−22時',
    '深夜',
    '早朝'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('時間帯')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: List.generate(
              data.length,
              (index) {
                var item = data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 160,
                    height: 60,
                    decoration: BoxDecoration(
                      color:
                          index == _selectedIndex ? Colors.amber : Colors.white,
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
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ButtonWidget(
              color: AppColor.primaryColor,
              title: 'OK',
              onPress: () {},
            ),
          )
        ],
      ),
    );
  }
}
