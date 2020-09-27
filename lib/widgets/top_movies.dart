import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_movies_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/screens/detail_screen.dart';
import 'package:movie_app/stlye/theme.dart' as Style;

class TopMovies extends StatefulWidget {
  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  @override
  void initState() {
    super.initState();
    moviesBloc..getMovies();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Text("TOP RATED MOVIES",style:TextStyle(
            color:Style.Colors.titleColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )),
        ),
        SizedBox(height: 5,),
        StreamBuilder<MovieResponse>(
      stream: moviesBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
             return _buildErrorWidget(snapshot.data.error);
          }
          return _buildMoviesWidget(snapshot.data);
        } else if (snapshot.hasData) {
            return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    )
      ],
    );
  }
  Widget _buildMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Center(
        child: Text("No Movies"),
      );
    } else {
      return Container(
        height: 280,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
            itemCount: movies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(movie: movies[index],)));
                  },
                                  child: Column(
                    children: [
                      movies[index].poster == null
                          ? Container(
                              width: 120,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Style.Colors.secondColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    EvaIcons.filmOutline,
                                    color: Colors.white,
                                    size: 50,
                                  )
                                ],
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 178,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://image.tmdb.org/t/p/w200/" +
                                              movies[index].poster))),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        child: Text(
                          movies[index].title,
                          maxLines: 2,
                          style: TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(children: [
                        Text(movies[index].rating.toString(),style:TextStyle(
                          color:Colors.white,
                          fontSize:10,
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(width: 5,),
                        RatingBar(
                          itemSize: 8,
                          initialRating: movies[index].rating/2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          allowHalfRating: true,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context,_)=>Icon(EvaIcons.star,color: Style.Colors.secondColor,),
                          onRatingUpdate: (rating){
                            print(rating);
                          },
                        )
                      ],)
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Error occured: $error")],
      ),
    );
  }
}