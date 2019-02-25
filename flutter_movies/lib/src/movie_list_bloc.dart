import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter_movies/serializers.dart';
import 'package:flutter_movies/src/movie.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

abstract class MovieListEvent {}

class MovieListFilterEvent extends MovieListEvent {
  final String query;
  MovieListFilterEvent({this.query});
}

enum MoviesType { newReleases, favorites }

class MovieListBloc {
  Stream<UnmodifiableListView<Movie>> get movies => _moviesSubject.stream;
  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  Sink<MoviesType> get moviesType => _moviesTypeController.sink;
  final _moviesTypeController = BehaviorSubject<MoviesType>();

  var _movies = <Movie>[];

  MovieListBloc() {
    _loadItems('upcoming');
    _moviesTypeController.stream.listen((moviesType) {
      switch (moviesType) {
        case MoviesType.favorites:
          _loadItems('top_rated');
          break;
        case MoviesType.newReleases:
          _loadItems('upcoming');
          break;
      }
    });

    _movieListEvents.stream.listen((event) {
      if (event is MovieListFilterEvent) {
        // TODO: event.query
        print(event.query);
      }
    });
  }

  void _loadItems(String resource) async {
    _isLoadingSubject.add(true);
    await _updateMovies(resource);
    _moviesSubject.add(UnmodifiableListView(_movies));
    _isLoadingSubject.add(false);
  }

  Future<Null> _updateMovies(String resource) async {
    var url = 'https://api.themoviedb.org/3/movie/$resource?api_key=aa0d387e519b001387da127a37f0acd2';
    http.Response response = await http.get(url);

    var data = json.decode(response.body);

    var moviesJson = data['results'] as List;
    var movies = moviesJson.map((json) {
      return standardSerializers.deserializeWith(Movie.serializer, json);
    }).toList();

    _movies = movies;
  }

  StreamController<MovieListEvent> _movieListEvents = StreamController();
  Sink<MovieListEvent> get moviesEvent => _movieListEvents.sink;

  void dispose() {
    _movieListEvents.close();
    _moviesTypeController.close();
    _isLoadingSubject.close();
  }
}
