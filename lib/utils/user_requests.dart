import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRequests {
  static final findById = (String id) async {
    return FirebaseFirestore.instance.collection("user").doc(id).get();
  };

  static final isRegistered = (String id) async {
    var res = await FirebaseFirestore.instance.collection("user").doc(id).get();
    return res.exists;
  };

  static final registerAccount = (
      {required String name,
      required String username,
      required String description,
      required String image,
      required DateTime dateOfBirth}) async {
    var exist = await FirebaseFirestore.instance
        .collection("user")
        .where("username", isEqualTo: username)
        .get();
    if (exist.size != 0) {
      return false;
    }
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "name": name,
      "username": username,
      "description": description,
      "image": image,
      "dateOfBirth": dateOfBirth.microsecondsSinceEpoch,
      "creationTimestamp": DateTime.now().millisecondsSinceEpoch
    });
    return true;
  };
}
