import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_movies/movie_details.dart';
import 'package:flutter_movies/src/movie.dart';
import 'package:flutter_movies/src/movie_cell.dart';
import 'package:flutter_movies/src/movie_list_bloc.dart';
import 'package:flutter_movies/src/provider/movies_provider.dart';

class SearchListBody extends StatefulWidget {
  @override
  _SearchListBodyState createState() => _SearchListBodyState();
}

class _SearchListBodyState extends State<SearchListBody> {
  @override
  Widget build(BuildContext context) {
    final bloc = MoviesProvider.of(context).bloc;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofocus: true,
            style: Theme.of(context).textTheme.title,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.all(10)),
            onSubmitted: (query) {
              bloc.moviesEvent.add(MovieListFilterEvent(query: query));
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: StreamBuilder<UnmodifiableListView<Movie>>(
                  stream: bloc.movies,
                  initialData: UnmodifiableListView<Movie>([]),
                  builder: (context, snapshot) {
                    return ListView(
                      children: snapshot.data.map((movie) {
                        return _buildItem(movie);
                      }).toList(),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(movie) {
    return MovieCell(movie, onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MovieDetail(movie);
      }));
    });
  }
}
