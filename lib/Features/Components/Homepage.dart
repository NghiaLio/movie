// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'CheckConnect.dart';
import '../Auth/Domain/Entities/UserModel.dart';
import '../Auth/Presentation/Cubit/authCubit.dart';
import '../Favorite/Presentation/Cubit/favoriteCubit.dart';
import '../Home/Presentation/Cubit/homeCubit.dart';
import '../Home/Presentation/Screen/Home.dart';
import '../MovieOfCategory/Presentation/Cubits/movieCubit.dart';
import '../MovieOfCategory/Presentation/Screen/movieListScreen.dart';
import '../Navigation/Cubits/navigationCubit.dart';
import '../Profiles/Presentation/Cubits/profileCubit.dart';
import '../Profiles/Presentation/Screen/profie.dart';

class Homepage extends StatefulWidget {
  bool isAuthen;
  Homepage({super.key, required this.isAuthen});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final authCubit = context.read<Authcubit>();

  late AppUser? user =
      authCubit.currentUser ?? AppUser(userName: "", email: "", uid: "");

  List<Widget> screen = [const home(), const Information(), const Profie()];

  bool isConnectedToInternet = true;

  StreamSubscription? _internetConnectionStreamSubcription;

  @override
  void initState() {
    _internetConnectionStreamSubcription =
        InternetConnection().onStatusChange.listen((event) {
      print(event);
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToInternet = true;
          });
          context.read<movieCubit>().getListMovieCategories();
          context.read<Homecubit>().getHome(user!.uid);
          if (user != null) {
            context.read<Profilecubit>().getProfile(user!.uid);
            context.read<Favoritecubit>().getFavoriteMovie(user!.uid);
          }
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
        default:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _internetConnectionStreamSubcription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isConnectedToInternet
        ? BlocBuilder<Navigationcubit, navigationSate>(
            builder: (context, state) {
            return Scaffold(
              body: screen[state.currentIndex],
              bottomNavigationBar: NavigationBar(
                elevation: 0,
                animationDuration: const Duration(milliseconds: 800),
                onDestinationSelected:
                    context.read<Navigationcubit>().updateIndex,
                selectedIndex: state.currentIndex,
                destinations: const <Widget>[
                  NavigationDestination(
                    icon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    label: 'Trang chủ',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.play_circle_fill, size: 30),
                    label: 'Phim',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_2_sharp, size: 30),
                    label: 'Cá nhân',
                  ),
                ],
              ),
            );
          })
        : const Checkconnect();
  }
}
