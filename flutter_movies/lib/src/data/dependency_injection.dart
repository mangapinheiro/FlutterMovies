import 'package:flutter_movies/src/data/movie_data.dart';
import 'package:flutter_movies/src/data/movie_data_mock.dart';
import 'package:flutter_movies/src/data/movie_data_prod.dart';

enum Flavor { prod, mock }

class Injector {
  static final Injector _singleton = Injector._internal();
  static Flavor _flavor;

  Injector._internal();

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  MovieRepository get movieRepository {
    switch (_flavor) {
      case Flavor.mock:
        return MockMovieRepository();
      default:
        return ProdMovieRepository();
    }
  }
}
