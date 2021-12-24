import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String singer;
  final String key;
  final String falsetto;
  final String genre;

  Song({
    required this.id,
    required this.title,
    required this.singer,
    required this.key,
    required this.falsetto,
    required this.genre,
  });

  factory Song.fromDocument(DocumentSnapshot doc) {
    final getDocs = doc.data() as Map<dynamic, dynamic>;
    return Song(
      id: doc.id,
      title: getDocs["title"],
      singer: getDocs["singer"],
      key: getDocs["key"],
      falsetto: getDocs["falsetto"],
      genre: getDocs["genre"],
    );
  }
}