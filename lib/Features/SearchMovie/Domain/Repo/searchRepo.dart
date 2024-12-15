import '../Entities/country.dart';

import '../Entities/searchMovie.dart';

abstract class searchRepo {
  Future<listCountry?> getListCountry();
  Future<listMovieofSearch?> getListMovieofCountry(String slugCountry);
  Future<listMovieofSearch?> getListMovieofSearch(String slugSuggest);
  Future<listMovieofSearch?> getListMovieofKeyword(String keyword);
}
