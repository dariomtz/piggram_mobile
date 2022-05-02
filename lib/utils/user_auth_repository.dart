import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //true ->go home page
  //false -> go login page
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<bool> isSignedInGoogle() async {
    return _googleSignIn.isSignedIn();
  }

  Future<void> signOutGoogleUser() async {
    await _googleSignIn.signOut();
  }

  Future<void> signoutFirebaseUser() async {
    await _auth.signOut();
  }

  Future<void> signInGoogle() async {
    //Google Sign In
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _auth.signInWithCredential(credential);
    User user = authResult.user!;
    await user.getIdToken();
  }

  Future<String?> SignInEmailPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      //'user-not-found' or 'wrong-password' exeptions
      return e.code;
    }
    return null;
  }

  Future<String?> RegisterEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      //'weak-password' or 'email-already-in-use' exeptions
      return e.code;
    } catch (e) {
      return e.toString();
    }
    return null;
  }
}