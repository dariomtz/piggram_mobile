import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggram_mobile/data/follow.dart';

class FollowRequests {
  static final CollectionReference<FollowData> followsRef =
      FirebaseFirestore.instance.collection("follow").withConverter<FollowData>(
          fromFirestore: (snap, _) => FollowData.fromJson(snap.data()!),
          toFirestore: (follow, _) => follow.toJson());

  static final getFollowers = (String id) async {
    return (await followsRef.where("followee", isEqualTo: id).get())
        .docs
        .map((follow) => follow.data())
        .toList();
  };

  static final getFollowing = (String id) async {
    return (await followsRef.where("follower", isEqualTo: id).get())
        .docs
        .map((follow) => follow.data())
        .toList();
  };
}
