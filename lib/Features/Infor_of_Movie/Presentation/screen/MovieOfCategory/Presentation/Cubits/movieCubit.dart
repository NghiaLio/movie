import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/Entities/MovieOfCategories.dart';
import '../../Domain/Repo/movieCategoris.dart';
import 'movieState.dart';

import '../../Domain/Entities/Categories.dart';

class movieCubit extends Cubit<movieStates>{
  
  final movieCategoriesRepo movieRepo;

  movieCubit({required this.movieRepo}) :super(initialMovie());
  // get Categories

  //get MovieOfCategories
  Future<ListMovieOfCategories?> getListMovieCategories() async{
    try {
      emit(loadingMovie());
      final data = await movieRepo.getListCategories();
      final result = <ListMovieOfCategories>[];
      if(data != null){
        List<Categories> list = data.listCategories;
        for( Categories e in list){
          final dataMovie = await movieRepo.getListMovieCategories(e.slug);
          if(dataMovie != null){
            result.add(dataMovie);
          }
        }
        emit(successLoadMovie(data, result));
      }else{
        emit(ErrorMovie());
      }
      
      
    } catch (e) {
      emit(ErrorMovie());
    }
  }
}