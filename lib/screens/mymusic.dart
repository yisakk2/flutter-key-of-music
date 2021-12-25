// models
import 'package:flutter/cupertino.dart';
import 'package:key/models/firebase_provider.dart';
// import 'package:key/models/users.dart';
// screens
import 'package:key/screens/like.dart';
import 'package:key/screens/profile.dart';
import 'package:key/screens/signin.dart';
// widgets
import 'package:key/widgets/progress.dart';
// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyMusic extends StatefulWidget {
  const MyMusic({Key? key}) : super(key: key);

  @override
  _MyMusicState createState() => _MyMusicState();
}

class _MyMusicState extends State<MyMusic> {
  var playlistNameController = TextEditingController();

  loggedOutPage() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('로그인하고 \n 내 플레이리스트를 확인해보세요.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
            MaterialButton(
              padding: EdgeInsets.all(20.0),
              child: Container(
                  width: 72,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: Colors.white30, width: 0.8)
                  ),
                  child: Center(
                    child: Text('로그인', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                  )
              ),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn())
                )
              },
            ),
          ],
        ),
      ),
    );
  }

  loggedInPage(FirebaseProvider fp) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // 좋아요 목록
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Like())
                  );
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: Icon(Icons.favorite_outline_rounded, color: Colors.white,),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                          '좋아요 보관함',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  '내 플레이리스트',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
        playList(fp),
      ],
    );
  }

  playList(FirebaseProvider fp) {
    return FutureBuilder(
      future: fp.getUsersPlaylists(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var playlists = snapshot.data! as List<String>;
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '전체 0',
                        // '전체 ${snapshot.data.docs.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '편집',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                MaterialButton(
                  onPressed: () {
                    addPlayList(fp);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add_outlined, color: Colors.white, size: 24,),
                        SizedBox(width: 5,),
                        Text(
                          '새로 만들기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                playlists.length == 0 ? noPlaylistExists() : playlistExists(),
              ],
            ),
          );
        } else {
          return circularProgress();
        }
      },
    );
  }

  addPlayList(FirebaseProvider fp) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Theme(
          data: ThemeData.dark(),
          child: CupertinoAlertDialog(
            title: Text('플레이리스트명', textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
            content: Padding(
              padding: EdgeInsets.fromLTRB(8, 24, 8, 0),
              child: CupertinoTextField(
                controller: playlistNameController,
                autofocus: true,
                padding: EdgeInsets.all(12.0),
                style: TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('취소', style: TextStyle(color: Colors.white30, fontSize: 14),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('확인', style: TextStyle(fontSize: 14),),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      }
    );
  }

  noPlaylistExists() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Center(
        child: Text(
          '플레이리스트가 없습니다.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
      ),
    );
  }

  playlistExists() {
    return SizedBox();
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
        title: Text('내음악'),
        backgroundColor: Colors.black,
        // actions: [
        //   if (fp.getUser() != null) loggedInAction(fp)
        // ],
      ),
      body: fp.getUser() == null ? loggedOutPage() : loggedInPage(fp)
    );
  }
}
