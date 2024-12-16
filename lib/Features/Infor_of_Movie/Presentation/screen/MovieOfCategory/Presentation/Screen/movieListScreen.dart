import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../Components/ErrorScreen.dart';
import '../../../../../../Components/Loading.dart';
import '../../Domain/Entities/Categories.dart';
import '../../Domain/Entities/MovieOfCategories.dart';
import '../Cubits/movieCubit.dart';
import '../Cubits/movieState.dart';
import 'Components/tabView.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  // itemMovie format

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<movieCubit, movieStates>(
      builder: (context, states) { 
        print(states);
        if (states is successLoadMovie) {
          List<Categories> categories = states.listCategories!.listCategories;
          List<Tab> tabTitle = categories
              .map((e) => Tab(
                    text: e.name,
                  ))
              .toList();
          List<ListMovieOfCategories?> movieOfCategories =
              states.listMovieOfCategories;
          return viewMovie(
            tabTitle: tabTitle,
            list: movieOfCategories,
          );
        }
        if(states is ErrorMovie){
          return const Errorscreen();
        } else {
          return const loadingIndicator();
        }
      },
    ));
  }
}
