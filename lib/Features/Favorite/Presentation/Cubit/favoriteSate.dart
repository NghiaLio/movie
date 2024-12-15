import '../../domain/Entities/Favorite.dart';

abstract class Favoritesate{}

class initialFavorite extends Favoritesate{}

class loadingFavorite extends Favoritesate{}

class loadedFavorite extends Favoritesate{
  ListFavorite? listFavorite;
  loadedFavorite(this.listFavorite);
}

class errorFavorite extends Favoritesate{}