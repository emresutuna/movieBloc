import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/stlye/theme.dart' as Style;
import 'package:movie_app/widgets/genres.dart';
import 'package:movie_app/widgets/now_playing.dart';
import 'package:movie_app/widgets/persons.dart';
import 'package:movie_app/widgets/top_movies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        title: Text("Movie App"),
        actions: [
          IconButton(icon: Icon(EvaIcons.searchOutline,color: Colors.white),onPressed: (){}),
        ],
        leading: Icon(EvaIcons.menu2Outline,color: Colors.white,),
      ),
      body: ListView(children: [
        NowPlaying(),
        GenresScreen(),
        PersonsList(),
        TopMovies()
      ],),
    );
  }
}
