import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_movies/movie_details.dart';
import 'package:flutter_movies/src/data/movie.dart';
import 'package:flutter_movies/src/movie_search_bloc.dart';
import 'package:flutter_movies/src/provider/search_provider.dart';
import 'package:flutter_movies/src/widgets/linear_progress_container.dart';
import 'package:flutter_movies/src/widgets/movie_cell.dart';

class SearchListBody extends StatefulWidget {
  @override
  _SearchListBodyState createState() => _SearchListBodyState();
}

class _SearchListBodyState extends State<SearchListBody> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = SearchProvider.of(context).bloc;
    var themeData = Theme.of(context);
    return NotificationListener(
      onNotification: notificationListener(using: bloc),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              style: themeData.textTheme.title,
              cursorColor: themeData.cursorColor,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: 'Search movie title',
                  contentPadding: EdgeInsets.all(10)),
              onChanged: (query) {
                _scrollController.animateTo(
                  0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
                bloc.moviesEvent.add(SearchEvent(query: query));
              },
            ),
          ),
          Expanded(child: _buildMoviesList(bloc)),
        ],
      ),
    );
  }

  Widget _buildMoviesList(SearchMoviesBloc bloc) {
    return LinearProgressContainer(
      stream: bloc.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder<UnmodifiableListView<Movie>>(
          stream: bloc.movies,
          initialData: UnmodifiableListView<Movie>([]),
          builder: (context, snapshot) {
            return ListView(
              controller: _scrollController,
              children: snapshot.data.map((movie) {
                return _buildItem(movie);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(movie) {
    return MovieCell(movie, onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MovieDetail(movie);
      }));
    });
  }

  NotificationListenerCallback<ScrollNotification> notificationListener({SearchMoviesBloc using}) {
    return (ScrollNotification notification) {
      var bloc = using;
      if (notification is ScrollUpdateNotification) {
        if (notification.metrics.maxScrollExtent > notification.metrics.pixels &&
            notification.metrics.maxScrollExtent - notification.metrics.pixels <= 100) {
          bloc.loadMore.add(null);
        }
      }

      return true;
    };
  }
}
