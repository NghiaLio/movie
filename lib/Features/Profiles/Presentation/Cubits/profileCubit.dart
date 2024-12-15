import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/Repo/UserProfileRepo.dart';
import 'profile_state.dart';

class Profilecubit extends Cubit<ProfileState>{

  final profileRepo profile_Repo;


  Profilecubit({required this.profile_Repo}) :super(initialProfile());

  // fetch user profile 
  Future<void> getProfile(String? uid) async{
    try {
      emit(loadingProfile());
      final data = await profile_Repo.fetchProfileUser(uid!);

      if(data != null){
        emit(loadedProfile(data));
      }else{
        emit(loadfail());
      }
    } catch (e) {
      emit(loadfail());
    }
  }
  // update name
  Future<void> updateName (String uid, String name)async{
    
    final code = profile_Repo.updateProfileUser(name, uid);

    // ignore: unrelated_type_equality_checks
    if(code == 200){
      getProfile(uid);
    }
  }

  //get favorite movie 
}