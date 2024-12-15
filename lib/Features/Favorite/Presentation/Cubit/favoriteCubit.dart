// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'favoriteSate.dart';
import '../../domain/Repo/favoriteRepo.dart';

import '../../domain/Entities/Favorite.dart';

class Favoritecubit extends Cubit<Favoritesate> {
  ListFavorite? _listFavorite;
  final Favoriterepo favoriterepo;

  Favoritecubit({required this.favoriterepo}) : super(initialFavorite());

  //fetch favorite movie
  Future<void> getFavoriteMovie(String? uid) async {
    try {
      emit(loadingFavorite());
      final data = await favoriterepo.fetchFavoriteMovie(uid!);

      _listFavorite = data;
      emit(loadedFavorite(data));
    } catch (e) {
      emit(errorFavorite());
    }
  }

  //get favorite movie
  ListFavorite? get listFavotite => _listFavorite;

  // delete a movie
  Future<void> deleteMovie(String uid, String idmovie) async {
    try {
      await favoriterepo.deleteOneMovie(uid, idmovie);
      await getFavoriteMovie(uid);
    } catch (e) {
      emit(errorFavorite());
    }
  }
}
