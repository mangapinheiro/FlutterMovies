import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_movies/movie_details.dart';
import 'package:flutter_movies/src/movie.dart';
import 'package:flutter_movies/src/movie_list_bloc.dart';
import 'package:flutter_movies/src/provider/movies_provider.dart';
import 'package:flutter_movies/src/widgets/linear_progress_container.dart';
import 'package:flutter_movies/src/widgets/movie_cell.dart';

class MovieList extends StatefulWidget {
  final Color mainColor;

  const MovieList({Key key, this.mainColor}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  Widget build(BuildContext context) {
    final bloc = MoviesProvider.of(context).bloc;
    return NotificationListener(
      onNotification: notificationListener(using: bloc),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MovieTitle(widget.mainColor),
            Expanded(
                child: LinearProgressContainer(
              stream: bloc.isLoading,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                ),
              ),
            ))
          ],
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

  NotificationListenerCallback<ScrollNotification> notificationListener({MovieListBloc using}) {
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

class MovieTitle extends StatelessWidget {
  final Color mainColor;

  MovieTitle(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Text(
        'Top Rated',
        style: TextStyle(fontSize: 40.0, color: mainColor, fontWeight: FontWeight.bold, fontFamily: 'Arvo'),
        textAlign: TextAlign.left,
      ),
    );
  }
}
