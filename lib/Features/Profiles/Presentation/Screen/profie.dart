import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Auth/Presentation/Cubit/authCubit.dart';
import '../../../Auth/Presentation/Cubit/auth_States.dart';
import '../../../Auth/Presentation/Screen/auth.dart';
import '../../../Components/ErrorScreen.dart';
import '../../../Components/Loading.dart';
import '../../Domain/Entities/Profile.dart';
import '../Cubits/profileCubit.dart';
import '../Cubits/profile_state.dart';
import 'profile_layout.dart';

class Profie extends StatefulWidget {
  const Profie({super.key});

  @override
  State<Profie> createState() => _ProfieState();
}

class _ProfieState extends State<Profie> {
  // login click or sign up click
  void clickAuth() async {
    // ignore: unused_local_variable
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => const authScreen(
                  isLoginError: false,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Authcubit, AuthStates>(builder: (context, state) {
      if (state is UnAuthenticated) {
        ProfileUser profileUser =
            ProfileUser(userName: "", email: "", uid: "", urlImage: "");
        return ProfileLayout(
          clickAuth: clickAuth,
          isAuthen: false,
          profileUser: profileUser,
        );
      }
      if (state is Authenticated) {
        return BlocBuilder<Profilecubit, ProfileState>(
            builder: (context, stateProfile) {
          print(stateProfile);
          if (stateProfile is loadedProfile) {
            ProfileUser? profileUser = stateProfile.profileUser;
            return ProfileLayout(
              clickAuth: clickAuth,
              isAuthen: true,
              profileUser: profileUser,
            );
          }
          if(stateProfile is loadfail){
            return const Errorscreen();
          } else {
            return const loadingIndicator();
          }
        });
      } else {
        return const loadingIndicator();
      }
    }, listener: (context, state) {
      if (state is Authenticated) {}
    });
  }
}
