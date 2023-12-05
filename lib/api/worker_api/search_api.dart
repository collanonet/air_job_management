import 'package:air_job_management/models/worker_model/search_job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

String errorMessage = "";

class SearchJobApi {
  var jobcollection = FirebaseFirestore.instance.collection('job');
  searchdata(
      {required access,
      required date,
      required description,
      required fromtime,
      required image,
      required note,
      required requirement,
      required Locations locations,
      createdAt,
      required List<Review> reviews,
      required totime,
      required title,
      required uid,
      required searchJobid,
      username}) {
    jobcollection.add({
      "access": access,
      "created_at": createdAt,
      "data": date,
      "description": description,
      "from_time": fromtime,
      "image": image,
      "location": {"des": locations.des, "lat": locations.lat, "lng": locations.lng, "name": ""},
      "note": note,
      "requirement": requirement,
      for (var i = 0; i < reviews.length; i++)
        "reviews": [
          {
            "comment": reviews[i].comment,
            "id": reviews[i].id,
            "name": reviews[i].name,
            "rate": reviews[i].rate,
          }
        ],
      "totime": totime,
      "tilte": title,
      "uid": uid,
      "search_job_id": searchJobid
    });
  }

  Future<bool> createJobRequest(String jobId, String userId, String username) async {
    try {
      var doc = await jobcollection.where("job_id", isEqualTo: jobId).where("user_id", isEqualTo: userId).get();
      if (doc.size == 0) {
        await jobcollection.add({"job_id": jobId, "user_id": userId, "created_at": DateTime.now(), "username": username, "status": "pending"});
        return true;
      } else {
        errorMessage = "You already apply this job! Please waiting company for accept to interview.";
        return false;
      }
    } catch (e) {
      debugPrint("Error createJobRequest $e");
      errorMessage = e.toString();
      return false;
    }
  }
}
