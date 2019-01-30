import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'movie.g.dart';

abstract class Movie implements Built<Movie, MovieBuilder> {
  static Serializer<Movie> get serializer => _$movieSerializer;

  String get title;

  String get overview;

  @BuiltValueField(wireName: 'poster_path')
  String get posterPath;

  @BuiltValueField(wireName: 'vote_average')
  double get voteAverage;

  Movie._();

  factory Movie([updates(MovieBuilder b)]) = _$Movie;
}
