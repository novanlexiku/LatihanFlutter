import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebaseuser
  User_models _fromFirebaseUser(User user) {
    return user != null ? User_models(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User_models> get user {
    return _auth.authStateChanges()
        // .map((User user) => _fromFirebaseUser(user));
    .map(_fromFirebaseUser);
  }

  // sign in anon
Future signInAnon() async {
  try {
    UserCredential userCredential = await _auth.signInAnonymously();
    User user = userCredential.user;
    return _fromFirebaseUser(user);
  } catch(e) {
    print(e.toString());
    return null;
  }
}

  // sign in with email and pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _fromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and pass
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // membuat document untuk user
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _fromFirebaseUser(user);

    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;

    }
}

}