// models
import 'package:key/models/firebase_provider.dart';
// import 'package:key/models/users.dart';
// screens
import 'package:key/screens/signin.dart';
import 'package:key/screens/profile.dart';
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
                onPressed: () {},
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
      future: fp.getUsersData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '전체 0',
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
              ],
            ),
          );
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
        title: Text('내음악'),
        backgroundColor: Colors.black,
        actions: [
          if (fp.getUser() != null) loggedInAction(fp)
        ],
      ),
      body: fp.getUser() == null ? loggedOutPage() : loggedInPage(fp)
    );
  }
}
