import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/models/appuser.dart' as model;

class Auth {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static model.AppUser currentUser = model.AppUser.none();

  Future<String> registerUser({
    required String name,
    required String bio,
    required String email,
    required String password,
  }) async {
    // check to make sure all fields are entered
    if (name.isEmpty || bio.isEmpty || email.isEmpty || password.isEmpty) {
      return "Please enter all fields.";
    }

    // returned string indicating whether or not operation was successful
    String res = "Some error occurred";

    try {
      // register user with firebase authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      model.AppUser _user = model.AppUser(
        userid: cred.user!.uid,
        name: name,
        bio: bio,
        email: email,
      );

      // add user to our database
      await _firestore
          .collection("users")
          .doc(cred.user!.uid)
          .set(_user.toMap());

      res = "success";
    } catch (err) {
      return err.toString();
    }

    return res;
  }
  

  Future<String> authenticateUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please enter all fields.";
    }

    String res = "Some error occurred at authenticateUser method";
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Auth.currentUser = await getUserDetails();
      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = model.AppUser.none();
  }

  Future<void> loadUserInfo() async {
    currentUser = await getUserDetails();
  }

  Future<model.AppUser> getUserDetails() async {
    User user = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(user.uid).get();

    return model.AppUser.fromSnap(documentSnapshot);
  }
}
