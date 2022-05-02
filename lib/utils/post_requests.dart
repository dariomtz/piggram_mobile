import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/utils/comment_requests.dart';
import 'package:piggram_mobile/utils/likes_requests.dart';
import 'package:piggram_mobile/utils/user_requests.dart';

class PostRequests {
  static final CollectionReference<PostData> postReq =
      FirebaseFirestore.instance.collection("post").withConverter(
          fromFirestore: (snap, _) {
            var t = snap.data()!;
            t["id"] = snap.id;
            return PostData.fromJson(t);
          },
          toFirestore: (post, _) => post.toJson());

  static Future<List<PostData>> getPosts() async {
    var postDocs =
        await postReq.limit(10).orderBy("publishedAt", descending: true).get();
    var posts = postDocs.docs.map((e) => e.data()).toList();
    for (var post in posts) {
      var userdoc = await UserRequests.findById(post.userId);
      post.user = userdoc.data();

      //Get likes of post
      post.likes = (await LikesRequests.getByPostId(post.id)).length;

      post.liked = (await LikesRequests.find(
              post.id, FirebaseAuth.instance.currentUser!.uid)) !=
          null;
      //Get list of comments
      post.comments = (await CommentRequests.getByPostId(post.id!)).length;
    }
    return posts;
  }

  static create(
      {required String description,
      required String image,
      required String userId}) async {
    await postReq.add(PostData.fromJson({
      "description": description,
      "image": image,
      "userId": userId,
      "publishedAt": Timestamp.fromDate(DateTime.now())
    }));
  }
}
