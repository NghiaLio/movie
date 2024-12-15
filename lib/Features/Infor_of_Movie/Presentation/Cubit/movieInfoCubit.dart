import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/Entities/movie.dart';
import '../../Domain/Entities/newCategories.dart';
import '../../Domain/Repo/movierepo.dart';
import 'movieInfoState.dart';
import '../../../MovieOfCategory/Domain/Entities/MovieOfCategories.dart';
import '../../../MovieOfCategory/Domain/Repo/movieCategoris.dart';

class MovieinfoCubit extends Cubit<MovieInfoState> {
  final Movierepo movierepo;
  final movieCategoriesRepo movie_categories_Repo;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  MovieinfoCubit({required this.movierepo, required this.movie_categories_Repo})
      : super(initialMovieInfo());

  //get information of movie
  Future<void> getMovieInfo(String slug) async {
    emit(loadingMovieInfo());
    try {
      //Infor_of_Movie
      final data = await movierepo.getMovieData(slug);

      if (data != null) {
        // category of movie
        final List<Newcategories> slugCategories = data.genre;
        //random 1 category
        Random random = Random();
        Newcategories randomCategory =
            slugCategories[random.nextInt(slugCategories.length)];

        //another movie
        final data2 = await movie_categories_Repo
            .getListMovieCategories(randomCategory.slug);

        if (data2 != null) {
          final list_movie = data2.listMovieOfCategories;
          final List<Movieofcategories> new_list = list_movie.where((element) {
            return element.id != data.id;
          }).toList();
          emit(loadedMovieInfo(data, new_list));
        }
      } else {
        emit(errorMovieInfo());
      }
    } catch (e) {
      emit(errorMovieInfo());
    }
  }

  //set favorite movie
  Future<void> setFavoriteMovie(movie favoriteMovie, String uid) async {
    final documnetRef = firebaseFirestore.collection('FavoriteMovie').doc(uid);

    try {
      final snapshot = await documnetRef.get();

      if (snapshot.exists) {
        // if data exists, update list
        List<dynamic> favoriteList = snapshot.data()?['favorite'] ?? [];
        favoriteList.add(favoriteMovie.toJson());

        //update List
        documnetRef
            .update({'favorite': favoriteList})
            .then((onValue) => print('upadte'))
            .catchError((onError) => print('edit'));
      } else {
        //if data not exists, create list
        documnetRef.set({
          'favorite': [favoriteMovie.toJson()]
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
