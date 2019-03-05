import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_movies/movie_details.dart';
import 'package:flutter_movies/src/movie.dart';
import 'package:flutter_movies/src/movie_cell.dart';
import 'package:flutter_movies/src/movie_list_bloc.dart';
import 'package:flutter_movies/src/movie_search.dart';
import 'package:flutter_movies/src/movie_search_bloc.dart';
import 'package:flutter_movies/src/provider/movies_provider.dart';
import 'package:flutter_movies/src/provider/search_provider.dart';

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  int _currentIndex = 0;

  MovieListBody _page1;
  Widget _page2;
  List<Widget> _pages;
  Widget _currentPage;

  @override
  void initState() {
    _page1 = MovieListBody(
      mainColor: mainColor,
    );

    _page2 = SearchProvider(bloc: SearchMoviesBloc(), child: SearchListBody());

    _pages = [_page1, _page2];

    _currentPage = _page1;

    super.initState();
  }

  Widget build(BuildContext context) {
    final bloc = MoviesProvider.of(context).bloc;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: LoadingInfo(bloc.isLoading),
        title: Text(
          'Movies',
          style: TextStyle(color: mainColor, fontFamily: 'Arvo', fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[Icon(Icons.menu, color: mainColor)],
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            title: Text('New Releases'),
            icon: Icon(Icons.new_releases),
          ),
          BottomNavigationBarItem(
            title: Text('Search'),
            icon: Icon(Icons.search),
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _currentPage = _pages[index];
          });
        },
      ),
    );
  }
}

class MovieListBody extends StatefulWidget {
  final Color mainColor;

  const MovieListBody({Key key, this.mainColor}) : super(key: key);

  @override
  _MovieListBodyState createState() => _MovieListBodyState();
}

class _MovieListBodyState extends State<MovieListBody> {
  @override
  Widget build(BuildContext context) {
    final bloc = MoviesProvider.of(context).bloc;
    return NotificationListener(
      onNotification: notificationListener(using: bloc),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MovieTitle(widget.mainColor),
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
    );
  }

  Widget _buildItem(movie) {
    return FlatButton(
      child: MovieCell(movie),
      padding: const EdgeInsets.all(0),
      color: Colors.white,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MovieDetail(movie);
        }));
      },
    );
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

class LoadingInfo extends StatelessWidget {
  final Stream<bool> _isLoading;

  LoadingInfo(
    this._isLoading, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _isLoading,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return Transform.scale(scale: 0.5, child: CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
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
