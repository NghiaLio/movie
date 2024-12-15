import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/Entities/Favorite.dart';
import '../domain/Repo/favoriteRepo.dart';

class GetfavoriteRepo implements Favoriterepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ListFavorite?> fetchFavoriteMovie(String uid) async {
    try {
      final documentRef =
          await firebaseFirestore.collection('FavoriteMovie').doc(uid).get();

      if (documentRef.exists) {
        final favorite_list = documentRef.data();
        if (favorite_list != null) {
          return ListFavorite.fromJson(favorite_list);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteOneMovie(String uid, String idMovie) async {
    try {
      final documentRef =
          await firebaseFirestore.collection('FavoriteMovie').doc(uid).get();

      if (documentRef.exists) {
        final favorite_list = documentRef.data();
        if (favorite_list != null) {
          List<dynamic> movie = favorite_list['favorite'];
          movie.removeWhere((e) => e['id'] == idMovie);
          await firebaseFirestore
              .collection('FavoriteMovie')
              .doc(uid)
              .update({'favorite': movie});
        }
      }else{
        return;
      }
    } catch (e) {
      return;
    }
  }

  @override
  Future<ListFavorite?> deleteAllMovie() {
    // TODO: implement deleteAllMovie
    throw UnimplementedError();
  }
}
