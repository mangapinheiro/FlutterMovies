import 'package:flutter/material.dart';
import 'package:flutter_movies/movie_details.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  void getData() async {
    var data = await getJson();

    setState(() {
      movies = data['results'];
    });
  }

  Widget build(BuildContext context) {
    getData();
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.3,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: new Icon(
          Icons.arrow_back,
          color: mainColor,
        ),
        title: new Text(
          'Movies',
          style: new TextStyle(color: mainColor, fontFamily: 'Arvo', fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          new Icon(
            Icons.menu,
            color: mainColor,
          )
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new MovieTitle(mainColor),
            new Expanded(
                child: new ListView.builder(
              itemCount: movies == null ? 0 : movies.length,
              itemBuilder: (context, index) {
                return FlatButton(
                  child: new MovieCell(movies, index),
                  padding: const EdgeInsets.all(0),
                  color: Colors.white,
                  onPressed: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (context){
                      return new MovieDetail(movies[index]);
                    }));
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  Future<Map> getJson() async {
    var url = 'http://api.themoviedb.org/3/discover/movie?api_key=aa0d387e519b001387da127a37f0acd2';
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }
}

class MovieCell extends StatelessWidget {
  final movies;
  final index;
  final Color mainColor = const Color(0xff3C3261);
  final imageUrl = 'https://image.tmdb.org/t/p/w500/';

  MovieCell(this.movies, this.index);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Container(
                margin: const EdgeInsets.all(16.0),
                child: new Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: new DecorationImage(
                      image: new NetworkImage(imageUrl + movies[index]['poster_path']), fit: BoxFit.cover),
                  boxShadow: [new BoxShadow(color: mainColor, blurRadius: 5.0, offset: new Offset(2.0, 5.0))],
                ),
              ),
            ),
            new Expanded(
                child: new Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: new Column(
                children: [
                  new Text(
                    movies[index]['title'],
                    style: new TextStyle(
                        fontSize: 20.0, fontFamily: 'Arvo', fontWeight: FontWeight.bold, color: mainColor),
                  ),
                  new Padding(padding: const EdgeInsets.all(2.0)),
                  new Text(
                    movies[index]['overview'],
                    maxLines: 3,
                    style: new TextStyle(color: const Color(0xff8785A4), fontFamily: 'Arvo'),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )),
          ],
        ),
        new Container(
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
    return new Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: new Text(
        'Top Rated',
        style: new TextStyle(fontSize: 40.0, color: mainColor, fontWeight: FontWeight.bold, fontFamily: 'Arvo'),
        textAlign: TextAlign.left,
      ),
    );
  }
}
