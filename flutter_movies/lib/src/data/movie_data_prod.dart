import 'dart:convert';

import 'package:flutter_movies/serializers.dart';
import 'package:flutter_movies/src/data/movie.dart';
import 'package:flutter_movies/src/data/movie_data.dart';
import 'package:http/http.dart' as http;

class ProdMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> fetchMovies(String resource, int page) async {
    var url =
        'https://api.themoviedb.org/3/movie/$resource?api_key=aa0d387e519b001387da127a37f0acd2&page=${page.toString()}';
    http.Response response = await http.get(url);

    var data = json.decode(response.body);

    var moviesJson = data['results'] as List;
    var movies = moviesJson.map((json) {
      return standardSerializers.deserializeWith(Movie.serializer, json);
    }).toList();

    return movies;
  }

  @override
  Future<List<Movie>> searchMovies(String query, int page) async {
    var url =
        'https://api.themoviedb.org/3/search/movie?api_key=aa0d387e519b001387da127a37f0acd2&page=${page.toString()}&query=$query';
    http.Response response = await http.get(url);

    var data = json.decode(response.body);

    var moviesJson = data['results'] as List;
    var movies = moviesJson.map((json) {
      return standardSerializers.deserializeWith(Movie.serializer, json);
    }).toList();

    return movies;
  }
}
