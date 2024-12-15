import '../../Domain/Entities/movie.dart';
import '../../../MovieOfCategory/Domain/Entities/MovieOfCategories.dart';

abstract class MovieInfoState{}

class initialMovieInfo extends MovieInfoState{}

class loadingMovieInfo extends MovieInfoState{}

class loadedMovieInfo extends MovieInfoState{
  movie? movieInfo;
  List<Movieofcategories?> listMovieOfCategories;
  loadedMovieInfo(this.movieInfo, this.listMovieOfCategories);
}

class errorMovieInfo extends MovieInfoState{}