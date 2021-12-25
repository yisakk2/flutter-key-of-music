import 'package:cloud_firestore/cloud_firestore.dart';

class Playlist {
  final List<String> title;

  Playlist({
    required this.title,
  });

  factory Playlist.fromDocument(DocumentSnapshot doc) {
    final getDocs = doc.data() as Map<String, dynamic>;
    return Playlist(
      title: getDocs["title"],
    );
  }
}