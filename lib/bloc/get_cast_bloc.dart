import 'package:flutter/material.dart';
import 'package:movie_app/model/cast_response.dart';
import 'package:movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CastsBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastResponse> _subject =
      BehaviorSubject<CastResponse>();
  getCasts(int id)async{
    CastResponse response= await _repository.ggetCasts(id);
    _subject.sink.add(response);
  }
  void drainStream(){_subject.value=null;}
  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }
  BehaviorSubject<CastResponse> get subject =>_subject;
}
final castsBloc =CastsBloc();