import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/like.dart';

class LikesRequests {
  static final CollectionReference<LikeData> likesRef =
      FirebaseFirestore.instance.collection("likes").withConverter(
          fromFirestore: (snap, _) {
            var t = snap.data()!;
            t["id"] = snap.id;
            return LikeData.fromJson(t);
          },
          toFirestore: (like, _) => like.toJson());

  static Future<List<LikeData>> getByPostId(id) async {
    return _getByParamId("postId", id);
  }

  static Future<List<LikeData>> getByUserId(id) async {
    return _getByParamId("userId", id);
  }

  static Future<List<LikeData>> _getByParamId(param, id) async {
    var likesDoc = await likesRef.where(param, isEqualTo: id).get();
    return likesDoc.docs.map((e) => e.data()).toList();
  }

  static Future<LikeData?> find(postId, userId) async {
    var likesDoc = await likesRef.where("postId", isEqualTo: postId).get();
    for (var like in likesDoc.docs) {
      if (like.data().userId == userId) {
        return like.data();
      }
    }
    return null;
  }
}
