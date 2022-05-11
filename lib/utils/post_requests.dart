import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/post.dart';
import 'package:piggram_mobile/data/tag.dart';
import 'package:piggram_mobile/utils/auth_requests.dart';
import 'package:piggram_mobile/utils/follow_requests.dart';
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

  static final CollectionReference<TagData> tagsRef = FirebaseFirestore.instance
      .collection("tags")
      .withConverter(
          fromFirestore: ((snap, _) => TagData.fromJson(snap.data()!)),
          toFirestore: (tag, _) => tag.toJson());

  static Future<List<PostData>> getPosts() async {
    List<String> following =
        (await FollowRequests.getFollowing(AuthRequests.currentUserId()))
            .map((follow) => follow.followee)
            .toList();

    var postDocs = await postReq
        .where("userId", whereIn: following)
        .orderBy("publishedAt", descending: true)
        .get();
    var posts = postDocs.docs.map((e) => e.data()).toList();
    for (var post in posts) {
      var userdoc = await UserRequests.findById(post.userId);
      post.user = userdoc.data();
    }
    return posts;
  }

  static Future<List<PostData>> getPostByUserId(String userId) async {
    var postsDoc = await postReq.where("userId", isEqualTo: userId).get();
    var posts = postsDoc.docs.map((e) => e.data()).toList();
    for (var post in posts) {
      var userdoc = await UserRequests.findById(post.userId);
      post.user = userdoc.data();
    }
    return posts;
  }

  static create(
      {required String description,
      required String image,
      required String userId}) async {
    List<String> tags = description
        .split(" #")
        .map(
          (e) => e.split(" ")[0],
        )
        .toList()
        .sublist(1);

    tags.forEach((tag) {
      PostRequests.createTag(tag);
    });

    await postReq.add(PostData.fromJson({
      "description": description,
      "image": image,
      "userId": userId,
      "publishedAt": Timestamp.fromDate(DateTime.now()),
      "tags": tags,
    }));
  }

  static createTag(String tag) {
    tagsRef.add(TagData(name: tag));
  }

  static Future<List<String>> searchTag(String query) async {
    QuerySnapshot<TagData> querySnapshot = await tagsRef
        .where("name", isGreaterThan: query)
        .where("name", isLessThan: query + '\uf8ff')
        .get();

    return querySnapshot.docs.map((snap) => snap.data().name).toList();
  }
}
