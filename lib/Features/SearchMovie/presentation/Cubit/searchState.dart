
import '../../Domain/Entities/country.dart';

import '../../Domain/Entities/searchMovie.dart';

abstract class Searchstate{}

class initialSearch extends Searchstate{}

class loadingSearch extends Searchstate{}

class loadedCountry extends Searchstate{
    listCountry? list_country;
    loadedCountry(this.list_country);
}

class loadedMovieofSuggest extends Searchstate{
    listMovieofSearch? listMovieSuggest;
    loadedMovieofSuggest(this.listMovieSuggest);
}

class loadedMovieofCountry extends Searchstate{
    listMovieofSearch? listMovieCountry;
    loadedMovieofCountry(this.listMovieCountry);
}
class loadedSearchbykeyword extends Searchstate{}
class errorSearch extends Searchstate{}