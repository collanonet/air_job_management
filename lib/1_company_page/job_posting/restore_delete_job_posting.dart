// import 'package:flutter/material.dart';
//
// import '../../models/job_posting.dart';
// import '../../utils/app_color.dart';
// import '../../widgets/loading.dart';
//
// class RestoreDeleteJobPostingPage extends StatefulWidget {
//   const RestoreDeleteJobPostingPage({super.key});
//
//   @override
//   State<RestoreDeleteJobPostingPage> createState() => _RestoreDeleteJobPostingPageState();
// }
//
// class _RestoreDeleteJobPostingPageState extends State<RestoreDeleteJobPostingPage> {
//
//   List<JobPosting> jobPostingList = [];
//   bool isLoading = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
//
//   buildList() {
//     if (isLoading) {
//       return Center(
//         child: LoadingWidget(AppColor.primaryColor),
//       );
//     } else {
//       if (jobPostingList.isNotEmpty) {
//         return ListView.separated(
//             itemCount: jobPostingProvider.jobPostingList.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             separatorBuilder: (context, index) =>
//                 Padding(padding: EdgeInsets.only(top: 10, bottom: index + 1 == jobPostingProvider.jobPostingList.length ? 20 : 0)),
//             itemBuilder: (context, index) {
//               JobPosting jobPosting = jobPostingProvider.jobPostingList[index];
//               return JobPostingCardForCompanyWidget(
//                 jobPosting: jobPosting,
//                 selectedJobPosting: selectedJobPosting,
//                 onClick: () {
//                   jobPostingProvider.onChangeSelectMenu(jobPostingProvider.tabMenu[0]);
//                   setState(() {
//                     selectedJobPosting = jobPosting;
//                   });
//                 },
//               );
//             });
//       } else {
//         return const Center(
//           child: EmptyDataWidget(),
//         );
//       }
//     }
//   }
// }
