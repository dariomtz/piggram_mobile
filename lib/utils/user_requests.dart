import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/data/profile.dart';
import 'package:piggram_mobile/data/user.dart';

class UserRequests {
  static final CollectionReference<UserData> usersRef =
      FirebaseFirestore.instance.collection("user").withConverter<UserData>(
          fromFirestore: (snap, _) => UserData.fromJson(snap.data()!),
          toFirestore: (user, _) => user.toJson());

  static final findById = (String id) async {
    return usersRef.doc(id).get();
  };

  static final isRegistered = (String id) async {
    var res = await usersRef.doc(id).get();
    return res.exists;
  };

  static final registerAccount = (
      {required String name,
      required String username,
      required String description,
      required String image,
      required DateTime dateOfBirth}) async {
    var exist = await usersRef.where("username", isEqualTo: username).get();
    if (exist.size != 0) {
      return false;
    }

    var user = UserData(
        displayName: name,
        username: username,
        description: description,
        photoUrl: image,
        dateOfBirth: dateOfBirth,
        creationTimestamp: DateTime.now());
    await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).set(user);
    return true;
  };

  static final getProfile = (String id) async {
    //Get user info from firebase
    var userInfo = await UserRequests.findById(id);
    UserData _user = userInfo.data()!;

    //get the count of followers
    var followersDoc = await FirebaseFirestore.instance
        .collection("follow")
        .where("followeeId", isEqualTo: id)
        .get();

    int followers = followersDoc.docs.length;

    //Get count of following
    var followingDoc = await FirebaseFirestore.instance
        .collection("follow")
        .where("followerId", isEqualTo: id)
        .get();

    int following = followingDoc.docs.length;

    //get posts from firebase
    var postsDoc = await FirebaseFirestore.instance
        .collection("post")
        .where("userId", isEqualTo: id)
        .get();

    var _posts = postsDoc.docs.map((post) => post.data()).toList();

    return ProfileData(
        user: _user, posts: _posts, followers: followers, following: following);
  };
}
