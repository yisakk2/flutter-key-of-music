// models
import 'package:key/models/song.dart';
import 'package:key/models/firebase_provider.dart';
// screens
import 'package:key/screens/profile.dart';
// widgets
import 'package:key/widgets/progress.dart';
// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Like extends StatefulWidget {
  const Like({Key? key}) : super(key: key);

  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> {

  _buildBody(FirebaseProvider fp) {
    return FutureBuilder(
      future: fp.getUsersLikeData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final songs = snapshot.data! as List<Song>;
          print(songs[0].title);
          return Container();
        } else {
          return circularProgress();
        }
      },
    );
  }

  loggedInAction(FirebaseProvider fp) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile())
        );
      },
      child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('profile_pic.jpg')
                )
            ),
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('좋아요'),
          backgroundColor: Colors.black,
          // actions: [
          //   if (fp.getUser() != null) loggedInAction(fp)
          // ],
        ),
        body: _buildBody(fp)
    );
  }
}
