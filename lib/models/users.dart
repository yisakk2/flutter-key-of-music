import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String email;
  final String imageUrl;
  final String nickname;

  Users({
    required this.id,
    required this.email,
    required this.imageUrl,
    required this.nickname,
  });

  factory Users.fromDocument(DocumentSnapshot doc) {
    final getDocs = doc.data() as Map<dynamic, dynamic>;
    return Users(
      id: doc.id,
      email: getDocs["email"],
      imageUrl: getDocs["imageUrl"],
      nickname: getDocs["nickname"],
    );
  }
}