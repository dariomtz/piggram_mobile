import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggram_mobile/data/follow.dart';
import 'package:piggram_mobile/data/profile.dart';
import 'package:piggram_mobile/data/user.dart';
import 'package:piggram_mobile/utils/follow_requests.dart';

class UserRequests {
  static final CollectionReference<UserData> usersRef =
      FirebaseFirestore.instance.collection("user").withConverter<UserData>(
          fromFirestore: (snap, _) => UserData.fromJson(snap.data()!),
          toFirestore: (user, _) => user.toJson());

  static final findById = (String id) async {
    return usersRef.doc(id).get();
  };

  static final findByUsername = (String username) async {
    return usersRef.where("username", isEqualTo: username).get();
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
    var exist = await UserRequests.findByUsername(username);
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

    List<FollowData> followers = await FollowRequests.getFollowers(id);
    List<FollowData> following = await FollowRequests.getFollowing(id);

    //get posts from firebase
    // TODO: Change this to post data list for profile
    var postsDoc = await FirebaseFirestore.instance
        .collection("post")
        .where("userId", isEqualTo: id)
        .get();

    var _posts = postsDoc.docs.map((post) => post.data()).toList();

    return ProfileData(
        user: _user, posts: _posts, followers: followers, following: following);
  };

  static final searchUser = (String query) async {
    //find by name
    var _docs = await usersRef
        .where("name", isGreaterThan: query)
        .where("name", isLessThan: query + '\uf8ff')
        .get();
    var _users = _docs.docs.map((doc) => doc.data()).toList();
    var _userset = _users.map((e) => e.username).toSet();

    //find by username
    _docs = await usersRef
        .where("username", isGreaterThan: query)
        .where("username", isLessThan: query + '\uf8ff')
        .get();

    //join results
    _docs.docs.map((doc) => doc.data()).forEach((doc) {
      if (!_userset.contains(doc.username)) {
        _users.add(doc);
      }
    });
    return _users;
  };
}
