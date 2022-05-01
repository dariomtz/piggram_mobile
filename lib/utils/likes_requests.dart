import 'package:cloud_firestore/cloud_firestore.dart';

class LikesRequests {
  static Future<List<Map<String, dynamic>>> getByPostId(id) async {
    return _getByParamId("postId", id);
  }

  static Future<List<Map<String, dynamic>>> getByUserId(id) async {
    return _getByParamId("userId", id);
  }

  static Future<List<Map<String, dynamic>>> _getByParamId(param, id) async {
    var likesDoc = await FirebaseFirestore.instance
        .collection("likes")
        .where(param, isEqualTo: id)
        .get();
    return likesDoc.docs.map((e) {
      var t = e.data();
      t["id"] = e.id;
      return t;
    }).toList();
  }

  static Future<Map<String, dynamic>?> find(postId, userId) async {
    var likesDoc = await FirebaseFirestore.instance
        .collection("likes")
        .where("postId", isEqualTo: postId)
        .get();
    for (var like in likesDoc.docs) {
      if (like.data()["userId"] == userId) {
        var t = like.data();
        t["id"] = like.id;
        return t;
      }
    }
    return null;
  }
}
