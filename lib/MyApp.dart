import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Features/Components/Loading.dart';
import 'Features/Auth/Data/firebaseAuth_repo.dart';
import 'Features/Auth/Presentation/Cubit/authCubit.dart';
import 'Features/Auth/Presentation/Cubit/auth_States.dart';
import 'Features/Auth/Presentation/Screen/auth.dart';
import 'Features/Favorite/Presentation/Cubit/favoriteCubit.dart';
import 'Features/Favorite/data/getFavorite.dart';
import 'Features/Home/Data/getDataHome_repo.dart';
import 'Features/Home/Presentation/Cubit/homeCubit.dart';
import 'Features/Infor_of_Movie/Data/getDataMovie.dart';
import 'Features/Infor_of_Movie/Presentation/Cubit/movieInfoCubit.dart';
import 'Features/MovieOfCategory/Data/getMovieRepo.dart';
import 'Features/MovieOfCategory/Presentation/Cubits/movieCubit.dart';
import 'Features/Navigation/Cubits/navigationCubit.dart';
import 'Features/Components/Homepage.dart';
import 'Features/Profiles/Data/DataProfileRepo.dart';
import 'Features/Profiles/Presentation/Cubits/profileCubit.dart';
import 'Features/SearchMovie/Data/getDataSearchRepo.dart';
import 'Features/SearchMovie/presentation/Cubit/searchCubit.dart';
import 'Theme/mode.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authRepo = FirebaseauthRepo();

  final comingRepo = getDataComingSoonRepo();

  final movieRepo = getMovieRepo();

  final profile_Repo = DataRepoProfile();

  final movieInfoRepo = Getdatamovie();

  final getdatasearchrepo = Getdatasearchrepo();

  final favoriterepo = GetfavoriteRepo();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<Authcubit>(
            create: (create) => Authcubit(authRepo: authRepo)..checkAuth()),
        BlocProvider<Homecubit>(
            create: (create) => Homecubit(Home: comingRepo)),
        BlocProvider<movieCubit>(
            create: (create) => movieCubit(movieRepo: movieRepo)),
        BlocProvider<Profilecubit>(
            create: (create) => Profilecubit(profile_Repo: profile_Repo)),
        BlocProvider<MovieinfoCubit>(
            create: (create) => MovieinfoCubit(
                movierepo: movieInfoRepo, movie_categories_Repo: movieRepo)),
        BlocProvider<Searchcubit>(
            create: (create) =>
                Searchcubit(getdatasearchrepo: getdatasearchrepo)
                  ..getCountry()),
        BlocProvider<Favoritecubit>(
            create: (create) => Favoritecubit(favoriterepo: favoriterepo)),
        BlocProvider<Navigationcubit>(create: (create) => Navigationcubit()),
      ],
      child: MaterialApp(
        title: 'The Movie',
        theme: darkMode,
        home: BlocConsumer<Authcubit, AuthStates>(
          builder: (context, authState) {
            print(authState);
            if (authState is UnAuthenticated) {
              return Homepage(
                isAuthen: false,
              );
            }
            if (authState is Authenticated) {
              return Homepage(
                isAuthen: true,
              );
            }
            if (authState is Error) {
              return const authScreen(
                isLoginError: true,
              );
            } else {
              return const loadingIndicator();
            }
          },
          listener: (context, state) {
            
          },
        ),
      ),
    );
  }
}
