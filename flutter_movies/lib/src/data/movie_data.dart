import 'package:flutter_movies/src/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetchMovies(String resource, int page);
  Future<List<Movie>> searchMovies(String query, int page);
}

class FetchDataException implements Exception {
  final _message;

  FetchDataException([this._message]);

  String toString() {
    if (_message == null) return 'Exception';
    return 'Exception $_message';
  }
}
