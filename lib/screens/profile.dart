// models
import 'package:key/models/firebase_provider.dart';
import 'package:key/models/users.dart';
// screens
// widgets
import 'package:key/widgets/progress.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  _buildBody(FirebaseProvider fp) {
    return Padding(
      padding: EdgeInsets.all(20),
      // padding: EdgeInsets.all(0),
      child: ListView(
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('profile_pic.jpg'),
                ),
                // FutureBuilder(
                //   future: fp.getImageUrl(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       var doc = snapshot.data as String;
                //       print(doc);
                //       return CircleAvatar(
                //           radius: 70,
                //           backgroundImage: NetworkImage(doc),
                //         );
                //     } else {
                //       return CircleAvatar(
                //         radius: 70,
                //         backgroundColor: Color.fromRGBO(154, 184, 211, 0),
                //       );
                //     }
                //   },
                // ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          FutureBuilder(
            future: fp.getUsersData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var users = snapshot.data as Users;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '닉네임',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      users.nickname,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        // fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 15,),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 15,),
                    Text(
                      '이메일',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      users.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        // fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: 15,),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                );
              } else {
                return circularProgress();
              }
            },
          ),
          InkWell(
            onTap: () {
              _profileAlert(fp);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '패스워드 재설정',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16,)
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              _profileSignOut(fp);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16,)
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              _profileWithDrawalAccount(fp);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '회원탈퇴',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16)
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  _profileSignOut(FirebaseProvider fp) async {
    fp.signOut();
    return Navigator.pop(context);
  }

  _profileWithDrawalAccount(FirebaseProvider fp) {
    fp.withdrawalAccount();
    return Navigator.pop(context);
  }

  _profileAlert(FirebaseProvider fp) {
    fp.pwResetEmail();
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Text('비밀번호 재설정'),
          content: Text('귀하의 이메일로 비밀번호 재설정 메일을 보냈습니다.'),
          actions: [
            CupertinoDialogAction(
              child: Text('확인'),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black,
      ),
      body: _buildBody(fp),
    );
  }
}
