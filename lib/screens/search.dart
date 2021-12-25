// models
import 'package:key/models/song.dart';
// screens
// widgets
import 'package:key/widgets/progress.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching = false;
  // String _searchText = "";

  // Firestore
  var songReference = FirebaseFirestore.instance.collection('songs');
  Future<QuerySnapshot>? futureSearchResults;
  Future<QuerySnapshot> allSongs = FirebaseFirestore.instance.collection('songs').where("title", isNotEqualTo: "").get();

  // Class
  List<ChildItem> searchSongResults = [];
  Future<Song>? likeSongs;
  // List<ChildItem> searchSongResults = [];

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    // futureSearchResults = songReference.where("title", isNotEqualTo: "").get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.black,
      appBar: buildBar(context),
      body: futureSearchResults == null ? displayNoSearchResultScreen() : displaySongFoundScreen(),
    );
  }

  buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        controller: _searchQuery,
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요.',
          hintStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white24,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12.0)
          ),
          filled: true,
          prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
          suffixIcon: _IsSearching ? IconButton(icon: Icon(Icons.clear, color: Colors.white, size: 20,), onPressed: _handleSearchEnd) : Icon(null),
        ),
        style: TextStyle(
            fontSize: 12,
            color: Colors.white
        ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  void _handleSearchEnd() {
    setState(() {
      _searchQuery.clear();
      futureSearchResults = null;
      _IsSearching = false;
    });
  }

  controlSearching(str) {
    if (str != '') {
      List<String> temp = [''];
      _IsSearching = true;

      songReference.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          Song likeSong = Song.fromDocument(element);
          if (likeSong.title.toLowerCase().contains(str.toLowerCase())) {
            temp.add(likeSong.title);
          }
        });

        Future<QuerySnapshot> searchedSongs = songReference.where('title', whereIn: temp).get();
        setState(() {
          futureSearchResults = searchedSongs;
        });
      });
    }
  }

  displayNoSearchResultScreen() {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.mic_none_rounded, color: Colors.grey, size: 150),
            Text(
              '노래를 검색하세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 30
              ),
            )
          ],
        ),
      ),
    );
  }


  displaySongFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        else if(snapshot.hasError) {
          return circularProgress();
        }
        else {
          print(snapshot.data!);
          List<ChildItem> searchSongResult = [];
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          docs.forEach((document) {
            Song songs = Song.fromDocument(document);
            ChildItem childItem = ChildItem(songs);
            searchSongResult.add(childItem);
          });

          return ListView(
            children: searchSongResult,
          );
        }
      },
    );
  }
}

class ChildItem extends StatelessWidget {
  final Song eachSong;
  ChildItem(this.eachSong);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(eachSong.title),
          ),
          Expanded(
            flex: 3,
            child: Text(eachSong.key, textAlign: TextAlign.right, style: TextStyle(fontSize: 12)),
          )
        ],
      ),
      subtitle: new Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(eachSong.singer, style: TextStyle(color: Colors.grey, fontSize: 11),),
          ),
          Expanded(
            flex: 3,
            child: Text(eachSong.falsetto, textAlign: TextAlign.right, style: TextStyle(color: Colors.grey, fontSize: 12)),
          )
        ],
      ),
      textColor: Colors.white,
      onTap: () => _moreInfo(context, eachSong),
    );
  }

  void _moreInfo(BuildContext context, Song songData) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Theme(
            data: ThemeData.dark(),
            child: CupertinoAlertDialog(
              title: Text(songData.title, textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(songData.singer, style: TextStyle(color: Colors.grey),),
                  Text(" "),
                  Text('진성: ${songData.key}', style: TextStyle(color: Colors.grey),),
                  if (songData.falsetto != "") Text('가성: ${songData.falsetto}', style: TextStyle(color: Colors.grey),),
                  Text('장르: ${songData.genre}', style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
          );
        }
    );
  }

}