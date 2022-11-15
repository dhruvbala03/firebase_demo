import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String userid;
  String name;
  String bio;
  final String email;

  // constructor
  AppUser({
    required this.userid,
    required this.name,
    required this.bio,
    required this.email,
  });

  static AppUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map;

    return AppUser(
      userid: snapshot["userid"],
      name: snapshot["name"],
      bio: snapshot["bio"],
      email: snapshot["email"],
    );
  }

  static AppUser none() {
    return AppUser(
      userid: "",
      name: "",
      bio: "",
      email: "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userid": userid,
      "name": name,
      "bio": bio,
      "email": email,
    };
  }
}
