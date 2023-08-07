import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status {
  uninitialized,
  authenticating,
  authenticated,
}

class AuthProvider extends ChangeNotifier {
  //  final SharedPreferences prefs;

  // AuthProvider(
  //       this.prefs);

  Status _status = Status.uninitialized;

  Status get static => _status;

  ///sign in method.
  Future<dynamic> signInWithGoogle() async {
    _status = Status.authenticating;
    notifyListeners();

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    //obtain the auth details from the request.
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    //create new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

final googleAuthProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) {
    return AuthProvider();
  },
);
