import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/Entities/ComingModel.dart';
import '../../Domain/Reppo/homeRepo.dart';
import 'homeState.dart';

class Homecubit extends Cubit<homeState>{
  // ModelComingSoon? _modelComingSoon;
  final HomeRepo Home;

  Homecubit({required this.Home}) : super(initialHome());  

  //getDataComingSoon
  Future<ModelComingSoon?> getHome(String? uid) async{
    try {
      emit(loadingHome());
      final dataComing = await Home.getDataComingSoon();
      final dataContinous = await Home.getContinousMovie(uid);

      if(dataComing != null){
        emit(SuccessHome(dataComing, dataContinous));
      }else{
        emit(getFail());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

}