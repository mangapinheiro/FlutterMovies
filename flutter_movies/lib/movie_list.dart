import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_movies/movie_details.dart';
import 'package:flutter_movies/serializers.dart';
import 'package:flutter_movies/src/movie.dart';
import 'package:flutter_movies/src/movie_list_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieList extends StatefulWidget {
  final MovieListBloc bloc;

  MovieList(this.bloc);

  @override
  MovieListState createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.arrow_back,
          color: mainColor,
        ),
        title: Text(
          'Movies',
          style: TextStyle(color: mainColor, fontFamily: 'Arvo', fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Icon(
            Icons.menu,
            color: mainColor,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MovieTitle(mainColor),
            Expanded(
                child: StreamBuilder<UnmodifiableListView<Movie>>(
                  stream: widget.bloc.movies,
                  initialData: UnmodifiableListView<Movie>([]),
                  builder: (context, snapshot) =>
                      ListView(
                        children: snapshot.data.map((movie) {
                          return _buildItem(movie);
                        }).toList(),
                      ),
                ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text('New Releases'),
            icon: Icon(Icons.new_releases),
          ),
          BottomNavigationBarItem(
            title: Text('Favorites'),
            icon: Icon(Icons.favorite),
          )
        ],
        onTap: (index) {
          if (index == 0) {
            widget.bloc.moviesType.add(MoviesType.newReleases);
          } else {
            widget.bloc.moviesType.add(MoviesType.favorites);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
}

class MovieCell extends StatelessWidget {
  final Movie movie;
  final Color mainColor = const Color(0xff3C3261);
  final imageUrl = 'https://image.tmdb.org/t/p/w500/';

  MovieCell(this.movie);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Hero(
                tag: movie.posterPath,
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey,
                    image: DecorationImage(image: NetworkImage(imageUrl + movie.posterPath), fit: BoxFit.cover),
                    boxShadow: [BoxShadow(color: mainColor, blurRadius: 5.0, offset: Offset(2.0, 5.0))],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Arvo', fontWeight: FontWeight.bold, color: mainColor),
                      ),
                      Padding(padding: const EdgeInsets.all(2.0)),
                      Text(
                        movie.overview,
                        maxLines: 3,
                        style: TextStyle(color: const Color(0xff8785A4), fontFamily: 'Arvo'),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                )),
          ],
        ),
        Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
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
