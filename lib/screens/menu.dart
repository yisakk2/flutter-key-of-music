// screens
import 'package:key/screens/signin.dart';
import 'package:key/screens/profile.dart';
// models
import 'package:key/models/firebase_provider.dart';
// import 'package:key/models/users.dart';
// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  _buildBody(FirebaseProvider fp) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: fp.getUser() == null ? _loggedOutWidget() : _loggedInWidget(fp)
          )
        ],
      ),
    );
  }

  _loggedInWidget(FirebaseProvider fp) {
    // Users user = fp.getUsersData();

    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile())
        );
      },
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('profile_pic.jpg'),
              radius: 25,
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 2, 12, 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // fp.getUsersData().nickname,
                      'Saks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    Text(
                      // user.nickname,
                      'kangic9659@gmail.com',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12
                      ),
                    )
                  ],
                ),
              )
            ),
            SizedBox(
              child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }

  _loggedOutWidget() {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignIn())
        );
      },
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('profile_pic.jpg'),
              radius: 25,
            ),
            Expanded(
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 2, 12, 2),
                  child: Text(
                    '로그인을 해주세요.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),
                  ),
                )
            ),
            SizedBox(
              child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('전체메뉴'),
        backgroundColor: Colors.black,
      ),
      body: _buildBody(fp),
    );
  }
}
