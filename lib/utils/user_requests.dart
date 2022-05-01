import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
