// models
import 'package:key/models/firebase_provider.dart';
// screens
import 'package:key/screens/home.dart';
import 'package:key/screens/search.dart';
import 'package:key/screens/mymusic.dart';
import 'package:key/screens/menu.dart';
// widgets
// packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBmqycTTP2PnZDWLLW7y5ZX1HLUt2BufPg',
      appId: '1:279003250906:android:a38fe92963e75e684ee5e3',
      messagingSenderId: '279003250906',
      projectId: 'key-of-music',
    )
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FirebaseProvider()),
    ],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Key',
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 2;

  final List<Widget> _children = [Home(), Search(), MyMusic(), Menu()];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white30,
        selectedFontSize: 9,
        unselectedFontSize: 9,
        onTap: _onTap,
        currentIndex: _currentIndex,
        backgroundColor: Colors.black87,
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          new BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          new BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: '내음악'),
          new BottomNavigationBarItem(icon: Icon(Icons.menu), label: '전체메뉴'),
        ],
      ),
    );
  }
}
