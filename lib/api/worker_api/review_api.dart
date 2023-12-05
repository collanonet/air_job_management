import 'package:air_job_management/models/worker_model/penalty_worker_model.dart';
import 'package:air_job_management/models/worker_model/review_worker_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/log.dart';

class ReviewAPI {
  final CollectionReference reviewRef = FirebaseFirestore.instance.collection('review_worker');
  final CollectionReference penaltyRef = FirebaseFirestore.instance.collection('penalty_worker');
  Future<List<ReviewWorkModel>?> fetchAllreview(String uid) async {
    try {
      late QuerySnapshot doc;
      doc = await reviewRef.where("worker_id", isEqualTo: uid).orderBy("created_at", descending: true).get();
      List<ReviewWorkModel> reviewList = [];
      if (doc.docs.isNotEmpty) {
        for (int i = 0; i < doc.docs.length; i++) {
          ReviewWorkModel reviewList = ReviewWorkModel.fromJson(doc.docs[i].data() as Map<String, dynamic>);
        }
        return reviewList;
      } else {
        return [];
      }
    } catch (e) {
      //print("Error fetchAllreview =>> ${e.toString()}");
      return [];
    }
  }

  Future<ReviewWorkModel?> getReview(String uid) async {
    try {
      DocumentSnapshot doc = (await FirebaseFirestore.instance.collection('review_worker').get()) as DocumentSnapshot<Object?>;
      if (doc.exists) {
        ReviewWorkModel review = ReviewWorkModel.fromJson(doc.data() as Map<String, dynamic>);
        return review;
      } else {
        return null;
      }
    } catch (e) {
      Logger.printLog("Error =>> ${e.toString()}");
      return null;
    }
  }

  Future<List<ReviewWorkModel>> getAllReview(String uid) async {
    try {
      QuerySnapshot doc = await await reviewRef.where("worker_id", isEqualTo: uid).orderBy("created_at", descending: true).get();
      //print("QuerySnapshot doc " + doc.size.toString());
      List<ReviewWorkModel> reviewList = [];
      if (doc.docs.isNotEmpty) {
        for (int i = 0; i < doc.docs.length; i++) {
          if (doc.docs[i].data().toString() != "{}") {
            ReviewWorkModel review = ReviewWorkModel.fromJson(doc.docs[i].data() as Map<String, dynamic>);
            reviewList.add(review);
          }
        }
        //print("reviewList" + reviewList.length.toString());
        return reviewList;
      } else {
        return [];
      }
    } catch (e) {
      //print("Error getAllReview =>> ${e.toString()}");
      return [];
    }
  }

  Future<List<PenaltyWorkModel>> getAllPenalty(String uid) async {
    try {
      QuerySnapshot doc = await await penaltyRef.where("worker_id", isEqualTo: uid).orderBy("created_at", descending: true).get();
      //print("QuerySnapshot doc " + doc.size.toString());
      List<PenaltyWorkModel> penaltyList = [];
      if (doc.docs.isNotEmpty) {
        for (int i = 0; i < doc.docs.length; i++) {
          if (doc.docs[i].data().toString() != "{}") {
            PenaltyWorkModel penalty = PenaltyWorkModel.fromJson(doc.docs[i].data() as Map<String, dynamic>);
            penaltyList.add(penalty);
          }
        }
        //print("reviewList" + penaltyList.length.toString());
        return penaltyList;
      } else {
        return [];
      }
    } catch (e) {
      //print("Error getAllPenalty =>> ${e.toString()}");
      return [];
    }
  }
}
