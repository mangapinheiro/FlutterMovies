import 'package:flutter/material.dart';
import 'package:flutter_movies/src/data/movie.dart';

class MovieCell extends StatelessWidget {
  final Movie movie;
  final Color mainColor = const Color(0xff3C3261);
  final imageUrl = 'https://image.tmdb.org/t/p/w500/';

  final onPressed;

  MovieCell(this.movie, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Hero(
                  tag: movie.title,
                  child: _buildThumbnail(),
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
                ),
              ),
            ],
          ),
          Container(
            width: 300.0,
            height: 0.5,
            color: const Color(0xD2D2E1ff),
            margin: const EdgeInsets.all(16.0),
          )
        ],
      ),
    );
  }

  Container _buildThumbnail() {
    if (movie.posterPath != null) {
      return Container(
        width: 90.0,
        height: 120.0,
        margin: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          color: Colors.grey,
          image: DecorationImage(image: NetworkImage(imageUrl + movie.posterPath), fit: BoxFit.cover),
          boxShadow: [BoxShadow(color: mainColor, blurRadius: 3.0, offset: Offset(2.0, 5.0))],
        ),
      );
    } else {
      return Container(
        width: 90.0,
        height: 120.0,
        child: Center(
          child: Icon(Icons.image),
        ),
      );
    }
  }
}
