import 'package:air_job_management/widgets/empty_data.dart';
import 'package:flutter/material.dart';

class ApplicationHistoryPage extends StatefulWidget {
  const ApplicationHistoryPage({Key? key}) : super(key: key);

  @override
  State<ApplicationHistoryPage> createState() => _ApplicationHistoryPageState();
}

class _ApplicationHistoryPageState extends State<ApplicationHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyDataWidget(),
    );
  }
}
