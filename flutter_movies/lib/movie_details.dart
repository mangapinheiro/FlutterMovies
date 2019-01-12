import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MovieDetail extends StatefulWidget {
  final movie;

  MovieDetail(this.movie);

  @override
  State<StatefulWidget> createState() {
    return MovieDetailState(movie);
  }
}

class MovieDetailState extends State<MovieDetail> {
  final imageUrl = 'https://image.tmdb.org/t/p/w500/';
  final Color mainColor = const Color(0xff3C3261);

  var movie;

  MovieDetailState(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(imageUrl + movie['poster_path'], fit: BoxFit.cover),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 400,
                      height: 400,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(imageUrl + movie['poster_path']), fit: BoxFit.cover),
                        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20, offset: Offset(0, 10))]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(movie['title'],
                                style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Arvo'))),
                        Text(
                          '${movie['vote_average']}/10',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Arvo'),
                        )
                      ],
                    ),
                  ),
                  Text(movie['overview'], style: TextStyle(color: Colors.white, fontFamily: 'Arvo')),
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
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xaa3C3261)),
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
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xaa3C3261)),
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
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
