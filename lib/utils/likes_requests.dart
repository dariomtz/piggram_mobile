import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/like.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

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

  static Future<UserData> getUserfromLike(LikeData like) async {
    return (await UserRequests.findById(like.userId)).data()!;
  }

  static Future<List<UserData>> getUsersfromList(List<LikeData> likes) async {
    List<UserData> users = [];
    for (var like in likes) {
      users.add((await getUserfromLike(like)));
    }
    return users;
  }

  static Future<bool> exist(String postId, String userId) async {
    return (await find(postId, userId)) != null;
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

  static Future<bool> create(String postId, String userId) async {
    if ((await exist(postId, userId) == true)) {
      return false;
    }
    likesRef.add(LikeData(postId: postId, userId: userId, id: ''));
    return true;
  }

  static Future<bool> delete(String postId, String userId) async {
    LikeData? like = await find(postId, userId);
    if (like == null) {
      return false;
    }
    likesRef.doc(like.id).delete();
    return true;
  }
}
