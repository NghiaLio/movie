import '../Entities/MovieOfCategories.dart';

import '../Entities/Categories.dart';

abstract class movieCategoriesRepo{
  Future<ListCategories?> getListCategories();
  Future<ListMovieOfCategories?> getListMovieCategories(String slug);
}