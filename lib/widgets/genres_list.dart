import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/stlye/theme.dart' as Style;
import 'package:movie_app/widgets/genre_movies.dart';

class GenresList extends StatefulWidget {
  final List<Genre>genres;
  GenresList({Key key,@required this.genres});
  @override
  _GenresListState createState() => _GenresListState(genres);
}

class _GenresListState extends State<GenresList> with SingleTickerProviderStateMixin{
  final List<Genre>genres;
  TabController tabController;
  _GenresListState(this.genres);
  @override
  void initState() {
    super.initState();
    tabController=TabController(vsync: this,length: genres.length);
    tabController.addListener(() { 
      if(tabController.indexIsChanging){
        moviesByGenreBloc..drainStream();
      }
    });
  }
  @override
  void dispose() { 
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 312,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.Colors.mainColor,
          appBar: PreferredSize(preferredSize: Size.fromHeight(50),child: AppBar(
            backgroundColor: Style.Colors.mainColor,
            bottom: TabBar(controller: tabController,
            indicatorColor: Style.Colors.secondColor,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Style.Colors.titleColor,
            labelColor: Colors.white,
            isScrollable: true,
            tabs: genres.map((Genre genre) {
              return Container(
                padding: EdgeInsets.only(bottom:15,top:10),
                child: Text(genre.name.toUpperCase(),style:TextStyle(
                  fontSize:14,
                  fontWeight: FontWeight.bold
                )),
              );
            }).toList()
            ),
          ),),
          body: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: genres.map((Genre genre) {
              return GenreMovies(genreId: genre.id,);
            }).toList()),
        ),
      ),
    );
  }
}