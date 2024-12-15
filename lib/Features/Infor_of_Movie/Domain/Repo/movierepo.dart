import '../Entities/movie.dart';

abstract class Movierepo{
  Future<movie?> getMovieData(String slug);
}