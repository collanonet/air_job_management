import 'package:flutter/material.dart';

enum SingingCharacter { a, b, c, d }

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  SingingCharacter? _character = SingingCharacter.a;
  List item = ['3,000円〜', '5,000円〜', '8,000円〜', '10,000円〜'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('報酬'),
      ),
      body: SafeArea(
        child: Column(
            children: List.generate(4, (index) {
          var value = item[index];
          return data(context, value);
        })),
      ),
    );
  }

  Widget data(BuildContext context, var value) {
    return ListTile(
      title: Text(value),
      leading: Radio<SingingCharacter>(
        value: SingingCharacter.b,
        groupValue: _character,
        onChanged: (SingingCharacter? value) {
          setState(() {
            _character = value;
          });
        },
      ),
    );
  }
}
