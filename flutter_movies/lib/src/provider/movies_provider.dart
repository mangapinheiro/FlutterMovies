import 'package:flutter/material.dart';
import 'package:flutter_movies/src/movie_list_bloc.dart';

class MoviesProvider extends InheritedWidget {
  final MovieListBloc bloc;

  const MoviesProvider({
    Key key,
    @required Widget child,
    this.bloc,
  })  : assert(child != null),
        super(key: key, child: child);

  static MoviesProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MoviesProvider) as MoviesProvider;
  }

  @override
  bool updateShouldNotify(MoviesProvider old) {
    return true;
  }
}
