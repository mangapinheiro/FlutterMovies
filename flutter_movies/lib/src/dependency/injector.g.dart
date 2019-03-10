// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void configure() {
    final Container container = Container();
    container.registerFactory<MovieRepository, ProdMovieRepository>(
        (c) => ProdMovieRepository());
  }

  void configureMock() {
    final Container container = Container();
    container.registerFactory<MovieRepository, MockMovieRepository>(
        (c) => MockMovieRepository());
  }
}
