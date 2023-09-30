import 'package:flutter/material.dart';

class CreateOrEditJobPage extends StatefulWidget {
  final String? jobPostId;
  const CreateOrEditJobPage({Key? key, required this.jobPostId})
      : super(key: key);

  @override
  State<CreateOrEditJobPage> createState() => _CreateOrEditJobPageState();
}

class _CreateOrEditJobPageState extends State<CreateOrEditJobPage> {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Text(widget.jobPostId != null
          ? "Edit Job Page ${widget.jobPostId}"
          : "Create Job Page"),
    );
  }
}
