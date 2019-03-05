import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  final movie;

  MovieDetail(this.movie);

  @override
  State<StatefulWidget> createState() {
    return MovieDetailState();
  }
}

class MovieDetailState extends State<MovieDetail> {
  final imageUrl = 'https://image.tmdb.org/t/p/w500/';
  final Color mainColor = const Color(0xff3C3261);

  MovieDetailState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildBackground(),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Column(
            children: <Widget>[
              AppBar(
                title: Text('Detail'),
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: <Widget>[
                          Hero(
                            tag: widget.movie.title,
                            child: Material(
                              color: Colors.transparent,
                              child: Cover(imageUrl: imageUrl, widget: widget),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(widget.movie.title,
                                        style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Arvo'))),
                                Text(
                                  '${widget.movie.voteAverage}/10',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Arvo'),
                                )
                              ],
                            ),
                          ),
                          Text(widget.movie.overview, style: TextStyle(color: Colors.white, fontFamily: 'Arvo')),
                          Padding(padding: const EdgeInsets.all(10.0)),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                width: 150.0,
                                height: 60.0,
                                alignment: Alignment.center,
                                child: Text('Rate Movie',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Arvo', fontSize: 20.0)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0), color: const Color(0xaa3C3261)),
                              )),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0), color: const Color(0xaa3C3261)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0), color: const Color(0xaa3C3261)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (widget.movie.posterPath == null) {
      return Container();
    }
    return Image.network(imageUrl + widget.movie.posterPath, fit: BoxFit.cover);
  }
}

class Cover extends StatelessWidget {
  const Cover({
    Key key,
    @required this.imageUrl,
    @required this.widget,
  }) : super(key: key);

  final String imageUrl;
  final MovieDetail widget;

  @override
  Widget build(BuildContext context) {
    if (widget.movie.posterPath == null) {
      return Container(
        width: 400,
        height: 400,
        child: Center(
          child: Icon(Icons.image),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            width: 400,
            height: 400,
          ),
          FavoriteWidget(),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(image: NetworkImage(imageUrl + widget.movie.posterPath), fit: BoxFit.cover),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20, offset: Offset(0, 10))]),
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorite = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      // If the lake is currently favorited, unfavorite it.
      if (_isFavorite) {
        _favoriteCount -= 1;
        _isFavorite = false;
        // Otherwise, favorite it.
      } else {
        _favoriteCount += 1;
        _isFavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white.withOpacity(0.3)),
        padding: EdgeInsets.only(left: 20),
        margin: EdgeInsets.only(right: 8, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 18,
              child: Text(
                '$_favoriteCount',
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: (_isFavorite ? Icon(Icons.star) : Icon(Icons.star_border)),
              color: Colors.white,
              onPressed: _toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
