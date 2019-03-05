import 'package:flutter/material.dart';
import 'package:flutter_movies/src/data/dependency_injection.dart';
import 'package:flutter_movies/src/movie_list.dart';
import 'package:flutter_movies/src/movie_list_bloc.dart';
import 'package:flutter_movies/src/provider/movies_provider.dart';

void main() {
  Injector.configure(Flavor.prod);
  runApp(MoviesProvider(bloc: MovieListBloc(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieList(),
    );
  }
}
