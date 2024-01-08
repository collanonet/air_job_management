import 'package:air_job_management/api/worker_api/withdraw_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmWithdraw extends StatefulWidget {
  final String? balance;
  final String? uid;
  final String? fullName;
  const ConfirmWithdraw(this.balance, this.uid, this.fullName);
  //const ConfirmWithdraw({Key? key}) : super(key: key);

  @override
  State<ConfirmWithdraw> createState() => _ConfirmWithdrawState();
}

class _ConfirmWithdrawState extends State<ConfirmWithdraw> {
  @override
  void initState() {
    super.initState();
    //print("initState ${isPending}");
  }

  bool isPending = false;

  Widget build(BuildContext context) {
    Color colorYellow = const Color(0xFFEDAD34);
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Container(
          child: AlertDialog(
            title: Text("Confirm Withdraw", style: TextStyle(color: colorYellow)),
            content: Text("Are you sure to withdraw ¥${widget.balance}?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    //MyPageRoute.goToReplace(context, const ViewProfile());
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    //print("clicked Yes");
                    bool checkPending = await WithdrawApi().isPending(widget?.uid);
                    if (checkPending) {
                      setState(() {
                        isPending = true;
                        //print('setState ' + isPending.toString());
                      });
                    } else {
                      WithdrawApi().Withdraw(
                          amount: widget.balance,
                          createdAt: DateTime.now(),
                          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          status: "pending",
                          time: DateFormat('kk:mm').format(DateTime.now()),
                          updatedAt: DateTime.now(),
                          workerID: widget.uid,
                          workerName: widget.fullName);

                      setState(() {
                        Navigator.pop(context);
                        isPending = false;
                        //print('setState ' + isPending.toString());
                      });
                    }
                  },
                  child: Text("Yes", style: TextStyle(color: colorYellow)))
            ],
          ),
        )),
        //bottomSheet: isPending == false ? const Text("") : const Text("You already requested this amount!  Please waiting for approval from admin."),
        bottomSheet: !isPending
            ? const Text("")
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Text(
                        "You already requested this amount!  Please waiting for approval from admin.",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
      ),
    );
  }
}
