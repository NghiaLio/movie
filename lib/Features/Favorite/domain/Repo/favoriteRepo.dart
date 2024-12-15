import '../Entities/Favorite.dart';

abstract class Favoriterepo{
  Future<ListFavorite?> fetchFavoriteMovie(String uid);
  Future<void> deleteOneMovie(String uid,String idMovie);
  Future<void> deleteAllMovie();
}