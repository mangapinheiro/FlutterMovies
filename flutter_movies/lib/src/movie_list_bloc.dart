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
  int _currentPage = 1;

  Stream<UnmodifiableListView<Movie>> get movies => _moviesSubject.stream;
  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  Sink<MoviesType> get moviesType => _moviesTypeController.sink;
  final _moviesTypeController = BehaviorSubject<MoviesType>();

  Sink<void> get loadMore => _loadMoreController.sink;
  final _loadMoreController = StreamController<void>();

  var _movies = <Movie>[];

  MovieListBloc() {
    _loadItems('upcoming');
    _moviesTypeController.stream.listen((moviesType) {
      _loadItems(resourceName(moviesType));
    });

    _movieListEvents.stream.listen((event) {
      if (event is MovieListFilterEvent) {
        // TODO: event.query
        print(event.query);
      }
    });

    _loadMoreController.stream.listen((_) {
      var resource = resourceName(_moviesTypeController.stream.value);
      _loadItems('upcoming');
    });
  }

  resourceName(MoviesType moviesType) {
    var resource;
    switch (moviesType) {
      case MoviesType.favorites:
        resource = 'top_rated';
        break;
      case MoviesType.newReleases:
        resource = 'upcoming';
        break;
    }
    return resource;
  }

  void _loadItems(String resource) async {
    if (isRequestInProgress) {
      return;
    }

    _isLoadingSubject.add(true);
    await _updateMovies(resource, _currentPage);
    _currentPage++;
    _moviesSubject.add(UnmodifiableListView(_movies));
    _isLoadingSubject.add(false);
  }

  bool get isRequestInProgress => _isLoadingSubject.stream.value;

  Future<Null> _updateMovies(String resource, int page) async {
    var url =
        'https://api.themoviedb.org/3/movie/$resource?api_key=aa0d387e519b001387da127a37f0acd2&page=${page.toString()}';
    http.Response response = await http.get(url);

    var data = json.decode(response.body);

    var moviesJson = data['results'] as List;
    var movies = moviesJson.map((json) {
      return standardSerializers.deserializeWith(Movie.serializer, json);
    }).toList();

    _movies.addAll(movies);
  }

  StreamController<MovieListEvent> _movieListEvents = StreamController();
  Sink<MovieListEvent> get moviesEvent => _movieListEvents.sink;

  void dispose() {
    _movieListEvents.close();
    _moviesTypeController.close();
    _isLoadingSubject.close();
    _loadMoreController.close();
  }
}
