// models
import 'dart:html';

import 'package:key/models/playlist.dart';
import 'package:key/models/song.dart';
import 'package:key/models/users.dart';
// screens
// widgets
// pakages
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Logger logger = Logger();

class FirebaseProvider with ChangeNotifier {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  User? _user;

  FirebaseProvider() {
    logger.d('init FirebaseProvider');
    _prepareUser();
  }

  User? getUser() {
    return _user;
  }

  void setUser(User? value) {
    _user = value;
    notifyListeners();
  }

  _prepareUser() {
    if (fAuth.currentUser != null) {
      setUser(fAuth.currentUser);
    }
    else setUser(null);
  }

  getUsersData() async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
    Users user = Users.fromDocument(documentSnapshot);

    return user;
  }

  getUsersLikeData() async {
    List<Song> songs = [];
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('like').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        Song song = Song.fromDocument(element);
        songs.add(song);
      });
    });

    return songs;
  }

  getUsersPlaylists() async {
    List<String> title = [];
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('playlist').doc('playlist').get().then((DocumentSnapshot documentSnapshot) {
      // return documentSnapshot['title'];
      // title = documentSnapshot['title'];
      Playlist playlist = Playlist.fromDocument(documentSnapshot);
      // print('haha');
      title = playlist.title;
    });

    return title;
  }

  getUsersPlaylistData() async {
    List<Song> songs = [];
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('like').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        Song song = Song.fromDocument(element);
        songs.add(song);
      });
    });

    return songs;
  }

  getImageUrl() async {
    var documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
    Users user = Users.fromDocument(documentSnapshot);
    // var imageUrl = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).toString();
    print(user.imageUrl);
    return user.imageUrl;
  }

  // 이메일/비밀번호로 회원가입
  Future<bool> signUpWithEmail(String email, String password, String passwordCheck, String nickname) async {
    bool flag = true;
    if (password != passwordCheck) flag = false;

    if (flag) {
      try {
        UserCredential result = await fAuth.createUserWithEmailAndPassword(email: email, password: password);
        if (result.user != null) {
          // 인증 메일 전송
          // result.user!.sendEmailVerification();
          await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
            'email': email,
            'imageUrl': 'gs://key-of-music.appspot.com/profile_pic.jpg',
            'nickname': nickname,
          });
          await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).collection('playlist').doc('playlist').set({
            'title': []
          });
          signOut();
          return true;
        }
        return false;
      } on Exception catch (e) {
        logger.e(e.toString());
        // List<String> result = e.toString().split(", ");
        // setLastFBMessage(result[1]);
        return false;
      }
    } else {
      return false;
    }
  }

  // 이메일/비밀번호로 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var result = await fAuth.signInWithEmailAndPassword(email: email, password: password);
      setUser(result.user);
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  // 패스워드 재설정 이메일
  pwResetEmail() async {
    String email = _user!.email as String;
    await fAuth.sendPasswordResetEmail(email: email);
  }

  // 로그아웃
  signOut() async {
    await fAuth.signOut();
    setUser(null);
  }

  // 회원탈퇴
  withdrawalAccount() async {
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).delete();
    await _user!.delete();
    setUser(null);
  }
}