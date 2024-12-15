import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/getDataSearchRepo.dart';
import '../../Domain/Entities/country.dart';
import '../../Domain/Entities/searchMovie.dart';
import 'searchState.dart';

class Searchcubit extends Cubit<Searchstate>{
  final Getdatasearchrepo getdatasearchrepo;

  Searchcubit({required this.getdatasearchrepo}):super(initialSearch());

  // get country
  Future<listCountry?> getCountry() async{
    emit(loadingSearch());
    try {
      final dataCountry = await getdatasearchrepo.getListCountry();
      if(dataCountry != null){
        emit(loadedCountry(dataCountry));
      }
      else{
        emit(errorSearch());
      }
    } catch (e) {
      emit(errorSearch());
    }
  }
  //get movie of country
  Future<listMovieofSearch?> getmovieCountry(String slugCountry ) async{
    emit(loadingSearch());
    try {
      final movieCountry = await getdatasearchrepo.getListMovieofCountry(slugCountry);
      if(movieCountry != null){
        emit(loadedMovieofCountry(movieCountry));
      }else{
        emit(errorSearch());
      }
    } catch (e) {
        emit(errorSearch());
      
    }
  }

  //get movie by suggest
  Future<listMovieofSearch?> getMoviebySuggest(String suggestion) async{
    emit(loadingSearch());
    try {
      final movieSuggest = await getdatasearchrepo.getListMovieofSearch(suggestion);
      if(movieSuggest != null){
        emit(loadedMovieofSuggest(movieSuggest));
      }else{
        emit(errorSearch());
      }
    } catch (e) {
      emit(errorSearch());
    }
  }

  //get movie by keyword
  List<Searchmovie?> _listSearch = [];
  Future<listMovieofSearch?> getMoviebykeyword(String suggestion) async{
    emit(loadingSearch());
    try {
      final movieSuggest = await getdatasearchrepo.getListMovieofKeyword(suggestion);
      if(movieSuggest != null){
        _listSearch = movieSuggest.listSearch;
        emit(loadedSearchbykeyword());
      }else{
        emit(errorSearch());
      }
    } catch (e) {
      emit(errorSearch());
    }
  }

  List<Searchmovie?> get listSearch => _listSearch;


}