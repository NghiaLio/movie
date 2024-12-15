// ignore_for_file: file_names

import '../../../WatchMovie/Domain/SaveTimeEntity.dart';
import '../Entities/ComingModel.dart';


abstract class HomeRepo{
  Future<ModelComingSoon?> getDataComingSoon();
  Future<SaveTimeEntity?> getContinousMovie(String? uid);
}