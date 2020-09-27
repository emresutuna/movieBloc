import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_movie_detail_bloc.dart';
import 'package:movie_app/model/movie_detail.dart';
import 'package:movie_app/model/movie_detail_response.dart';
import 'package:movie_app/stlye/theme.dart' as Style;

class MovieInfo extends StatefulWidget {
  final int id;
  MovieInfo({Key key ,@required this.id}):super(key:key);
  @override
  _MovieInfoState createState() => _MovieInfoState(id);
}

class _MovieInfoState extends State<MovieInfo> {
  final int id;
  _MovieInfoState(this.id);
  @override
  void initState() {
    super.initState();
    movieDetailBloc..getMovieDetail(id);
  }
  @override
  void dispose() { 
    super.dispose();
    movieDetailBloc..drainStream();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
            stream: movieDetailBloc.subject.stream,
            builder: (context, AsyncSnapshot<MovieDetailResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _buildErrorWidget(snapshot.data.error);
                }
                return _buildInfoWidget(snapshot.data);
              } else if (snapshot.hasData) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          );
  }
  Widget _buildInfoWidget(MovieDetailResponse data){
    MovieDetail detail =data.movieDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:10.0,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("BUDGET" ,style: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                                  SizedBox(height: 10,),
                                  Text(detail.budget.toString()+ " \$",
                                   style: TextStyle(
                                  color: Style.Colors.secondColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)
                                  )
                ],
              ),
                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("DURATION" ,style: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                                  SizedBox(height: 10,),
                                  Text(detail.runtime.toString()+ " min",
                                   style: TextStyle(
                                  color: Style.Colors.secondColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)
                                  )
                ],
              ),
                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("RELEASE DATA" ,textAlign: TextAlign.center,style: TextStyle(
                                  color: Style.Colors.titleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                                  SizedBox(height: 10,),
                                  Text(detail.releaseDate,
                                   style: TextStyle(
                                  color: Style.Colors.secondColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)
                                  )
                ],
              ),
            ],
          ),
          
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                 padding: const EdgeInsets.only(bottom:5.0,top:5),
                 child: Text("GENRES" ,textAlign: TextAlign.center,style: TextStyle(
                                    color: Style.Colors.titleColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12)),
               ),
              Container(height: 38,
              padding: EdgeInsets.only(right:10,left:10,top:5),
              child: ListView.builder(itemBuilder: (context,index){
                return Container(
                  padding: EdgeInsets.only(right:10,left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border:Border.all(
                      width:1,color:Colors.white
                    )
                  ),
                  child: Center(child: Text(detail.genres[index].name,textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontWeight: FontWeight.w300,fontSize:11.0),)),
                );
              },itemCount: detail.genres.length,scrollDirection: Axis.horizontal,),
              ),
            ],
          ),
        ),
      ],
    );
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
        children: [
          Text("Error occured: $error", style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}