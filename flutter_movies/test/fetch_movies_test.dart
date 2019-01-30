
import 'package:flutter_movies/json_parsing.dart';
import 'package:test_api/test_api.dart';
import 'package:flutter_movies/src/movie.dart';
import 'package:flutter_movies/serializers.dart';
import 'dart:convert' as json;

void main() {
  test("", () {
    const jsonString = """
      {
        "title": "title",
        "overview": "overview",
        "poster_path": "posterPath"
      }
    """;
    var movieData = json.jsonDecode(jsonString);
    Movie movie = standardSerializers.deserializeWith(Movie.serializer, movieData);
    expect(movie.title, 'title');
    expect(movie.overview, 'overview');
    expect(movie.posterPath, 'posterPath');
  });
}
