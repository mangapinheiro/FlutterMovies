import 'package:flutter_movies/src/data/movie_data.dart';
import 'package:flutter_movies/src/data/movie_data_mock.dart';
import 'package:flutter_movies/src/data/movie_data_prod.dart';
import 'package:kiwi/kiwi.dart';

part 'injector.g.dart';

enum Flavor { prod, mock }

abstract class Injector {
  @Register.factory(MovieRepository, from: ProdMovieRepository)
  void configure();

  @Register.factory(MovieRepository, from: MockMovieRepository)
  void configureMock();
}

void setupInjection(Flavor flavor) {
  var injector = _$Injector();
  switch (flavor) {
    case Flavor.prod:
      injector.configure();
      break;
    case Flavor.mock:
      injector.configureMock();
      break;
  }
}
