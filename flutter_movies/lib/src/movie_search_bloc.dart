import 'dart:async';
import 'dart:collection';

import 'package:flutter_movies/src/data/dependency_injection.dart';
import 'package:flutter_movies/src/movie.dart';
import 'package:rxdart/rxdart.dart';

abstract class MovieSearchEvent {}

class SearchEvent extends MovieSearchEvent {
  final String query;
  SearchEvent({this.query});
}

enum MoviesType { newReleases, favorites }

class SearchMoviesBloc {
  int _currentPage = 1;

  Stream<UnmodifiableListView<Movie>> get movies => _moviesSubject.stream;
  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  Sink<void> get loadMore => _loadMoreController.sink;
  final _loadMoreController = StreamController<void>();

  var _movies = <Movie>[];
  String _query = '';

  SearchMoviesBloc() {
    DebounceStreamTransformer(Duration(milliseconds: 500)).bind(_movieListEvents.stream).listen((event) {
      if (event is SearchEvent) {
        print(event.query);
        _query = event.query;
        _currentPage = 1;
        _movies = [];
        _loadItems(_query);
      }
    });

    _loadMoreController.stream.listen((_) {
      _loadItems(_query);
    });
  }

  void _loadItems(String query) async {
    if (isRequestInProgress) {
      return;
    }

    if (query == null || query.isEmpty) {
      _movies = [];
      _moviesSubject.add(UnmodifiableListView(_movies));
      return;
    }

    _isLoadingSubject.add(true);
    await _updateMovies(query, _currentPage);
    _currentPage++;
    _moviesSubject.add(UnmodifiableListView(_movies));
    _isLoadingSubject.add(false);
  }

  bool get isRequestInProgress => _isLoadingSubject.stream.value;

  Future<Null> _updateMovies(String query, int page) async {
    final movies = await Injector().movieRepository.searchMovies(query, page);
    _movies.addAll(movies);
  }

  StreamController<MovieSearchEvent> _movieListEvents = StreamController();
  Sink<MovieSearchEvent> get moviesEvent => _movieListEvents.sink;

  void dispose() {
    _movieListEvents.close();
    _isLoadingSubject.close();
    _loadMoreController.close();
  }
}
