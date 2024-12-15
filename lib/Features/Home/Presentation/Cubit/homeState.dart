

import '../../../WatchMovie/Domain/SaveTimeEntity.dart';
import '../../Domain/Entities/ComingModel.dart';

abstract class homeState{
  
}

//initial
class initialHome extends homeState{

}
// loading 
class loadingHome extends homeState{

}
//Success get coming
class SuccessHome extends homeState{
  SaveTimeEntity? saveTimeEntity;
  ModelComingSoon? comingData;
  SuccessHome(this.comingData, this.saveTimeEntity);
}

//Success get continous

//Error
class getFail extends homeState{
  
}