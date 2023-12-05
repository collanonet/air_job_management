import 'package:air_job_management/models/worker_model/privacy_model.dart';
import 'package:air_job_management/widgets/empty_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivatePolicy extends StatefulWidget {
  const PrivatePolicy({Key? key}) : super(key: key);

  @override
  State<PrivatePolicy> createState() => _PrivatePolicyState();
}

class _PrivatePolicyState extends State<PrivatePolicy> {
  late final WebViewController controller;
  late String privacyUrl = '';
  List<PrivacyModel> privacyModel = [];
  var loadingPercentage = 0;
  bool hasURL = true;

  @override
  void initState() {
    onGetDataPrivatePolicy();
    super.initState();
  }

  onGetDataPrivatePolicy() async {
    privacyModel = [];
    var dataPrivatePolicy = await FirebaseFirestore.instance.collection("privacy_setting").limit(1).get();

    if (dataPrivatePolicy.size > 0) {
      for (var d in dataPrivatePolicy.docs) {
        var infoPrivatePolicy = PrivacyModel.fromJson(d.data());
        privacyModel.add(infoPrivatePolicy);
        privacyUrl = infoPrivatePolicy.privacy_url;
        //print("'$privacyUrl'");

        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                loadingPercentage = 0;
              });
            },
            onProgress: (int progress) {
              // print the loading progress to the console
              // you can use this value to show a progress bar if you want
              //debugPrint("Loading: $progress%");
              setState(() {
                loadingPercentage = progress;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ))
          //..loadRequest(Uri.parse('https://www.freeprivacypolicy.com/live/d01ba425-308a-472c-b1fb-8cd0170a753f'));
          ..loadRequest(Uri.parse(privacyUrl.trim()));
      }
    } else {
      setState(() {
        hasURL = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Private Policy", style: TextStyle(color: Color(0xFFEDAD34))),
        centerTitle: true,
      ),
      body: hasURL
          ? loadingPercentage < 100
              ? const Center(child: CupertinoActivityIndicator())
              : WebViewWidget(controller: controller)
          : const Center(child: EmptyDataWidget()),
    );
  }
}
