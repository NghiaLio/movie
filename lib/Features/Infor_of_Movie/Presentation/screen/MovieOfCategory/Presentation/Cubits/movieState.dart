import '../../Domain/Entities/Categories.dart';
import '../../Domain/Entities/MovieOfCategories.dart';

abstract class movieStates{

}
// initial
class initialMovie extends movieStates{

}
//loading
class loadingMovie extends movieStates{

}

//SuccessLoading
class successLoadMovie extends movieStates{
  ListCategories? listCategories;
  List<ListMovieOfCategories?> listMovieOfCategories;
  successLoadMovie(this.listCategories, this.listMovieOfCategories);
}

//Error listCategories
class ErrorMovie extends movieStates{
  
}