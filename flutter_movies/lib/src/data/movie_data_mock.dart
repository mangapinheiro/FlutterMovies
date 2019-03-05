import 'package:flutter_movies/src/data/movie_data.dart';
import 'package:flutter_movies/src/movie.dart';

class MockMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> fetchMovies(String resource, int page) {
    return null;
  }

  @override
  Future<List<Movie>> searchMovies(String resource, int page) {
    // TODO: implement searchMovies
    return null;
  }
}
