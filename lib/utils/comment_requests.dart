import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/comment.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

class CommentRequests {
  static final CollectionReference<CommentData> commentReq =
      FirebaseFirestore.instance.collection("comment").withConverter(
          fromFirestore: (snap, _) {
            var t = snap.data()!;
            t["id"] = snap.id;
            return CommentData.fromJson(t);
          },
          toFirestore: (comment, _) => comment.toJson());

  static Future<List<CommentData>> getByPostId(String id) async {
    var commentsDoc = await commentReq.where("postId", isEqualTo: id).get();
    var comments = commentsDoc.docs.map((e) => e.data()).toList();
    for (var comment in comments) {
      comment.user = (await UserRequests.findById(comment.userId)).data();
    }
    return comments;
  }

  static Future<List<CommentData>> getByUserId(String id) async {
    var commentsDoc = await commentReq.where("userId", isEqualTo: id).get();
    return commentsDoc.docs.map((e) => e.data()).toList();
  }

  static Future<void> create(
      {required String description,
      required String postId,
      required String userId}) async {
    commentReq.add(CommentData(
        description: description,
        postId: postId,
        userId: userId,
        publishedAt: DateTime.now()));
  }

  static Future<void> delete(String id) async {
    commentReq.doc(id).delete();
  }

  static Future<CommentData?> find(
      {required String postId, required String userId}) async {
    var commentsDocs =
        await commentReq.where("postId", isEqualTo: postId).get();
    for (var comment in commentsDocs.docs) {
      if (comment.data().userId == userId) {
        return comment.data();
      }
    }
    return null;
  }
}
