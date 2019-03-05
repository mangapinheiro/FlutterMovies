import 'package:flutter/material.dart';
import 'package:flutter_movies/src/movie_search_bloc.dart';

class SearchProvider extends InheritedWidget {
  final SearchMoviesBloc bloc;

  const SearchProvider({
    Key key,
    @required Widget child,
    this.bloc,
  })  : assert(child != null),
        super(key: key, child: child);

  static SearchProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(SearchProvider) as SearchProvider;
  }

  @override
  bool updateShouldNotify(SearchProvider old) {
    return true;
  }
}
