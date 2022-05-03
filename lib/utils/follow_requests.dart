import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/follow.dart';
import 'package:piggram_mobile/utils/user_auth_repository.dart';

class FollowRequests {
  static final CollectionReference<FollowData> followsRef =
      FirebaseFirestore.instance.collection("follow").withConverter<FollowData>(
          fromFirestore: (snap, _) => FollowData.fromJson(snap.data()!),
          toFirestore: (follow, _) => follow.toJson());

  static final String follower = "followerID";
  static final String followee = "followeeID";

  static final getFollowers = (String id) async {
    return (await followsRef.where(followee, isEqualTo: id).get())
        .docs
        .map((follow) => follow.data())
        .toList();
  };

  static final getFollowing = (String id) async {
    return (await followsRef.where(follower, isEqualTo: id).get())
        .docs
        .map((follow) => follow.data())
        .toList();
  };

  static final follow = (String id, bool follow) async {
    if (follow) {
      await followsRef.add(FollowData(
          followee: id, follower: UserAuthRepository.currentUserId()));
    } else {
      QuerySnapshot<FollowData> follows = await followsRef
          .where(followee, isEqualTo: id)
          .where(follower, isEqualTo: UserAuthRepository.currentUserId())
          .get();

      follows.docs.forEach((element) => element.reference.delete());
    }
  };

  static final amIFollowing = (String id) async {
    QuerySnapshot<FollowData> follows = await followsRef
        .where(followee, isEqualTo: id)
        .where(follower, isEqualTo: UserAuthRepository.currentUserId())
        .get();
    return follows.docs.length != 0;
  };
}
