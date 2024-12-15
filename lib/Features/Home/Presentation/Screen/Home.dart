import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../Auth/Presentation/Cubit/authCubit.dart';
import '../../../Auth/Presentation/Cubit/auth_States.dart';
import '../../../Components/ErrorScreen.dart';
import '../../../WatchMovie/Domain/SaveTimeEntity.dart';
import '../../../Components/Loading.dart';
import '../../../WatchMovie/Presentation/watchmovie.dart';
import '../../Domain/Entities/ComingModel.dart';
import '../Cubit/homeCubit.dart';
import '../Cubit/homeState.dart';
import '../../../Infor_of_Movie/Presentation/screen/movieInfoScreen.dart';

class home extends StatefulWidget {
  const home({
    super.key,
  });

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late bool isAuthen;

  void onTapMovie(String slug, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => Movieinfoscreen(
            idMovie: id,
            slugMovie: slug,
          ),
        ));
  }

  void watchMovie(SaveTimeEntity saveTimeEntity) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Movieinfoscreen(
                slugMovie: saveTimeEntity.slug,
                idMovie: saveTimeEntity.idMovie)));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Watchmovie(
                  uid: saveTimeEntity.uid,
                  posterUrl: saveTimeEntity.posterUrl,
                  nameEpisode: saveTimeEntity.nameEpisoda,
                  movieUrl: saveTimeEntity.movieUrl,
                  time: saveTimeEntity.time,
                  slug: saveTimeEntity.slug,
                  idMovie: saveTimeEntity.idMovie,
                )));
  }

  @override
  void initState() {
    final checkAuth = context.read<Authcubit>().state;
    if (checkAuth is Authenticated) {
      setState(() {
        isAuthen = true;
      });
    } else {
      setState(() {
        isAuthen = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: BlocBuilder<Homecubit, homeState>(builder: (context, state) {
      print(state);
      if (state is SuccessHome) {
        final SaveTimeEntity saveTimeEntity = state.saveTimeEntity ??
            SaveTimeEntity(
                uid: "",
                time: "",
                movieUrl: "",
                nameEpisoda: "",
                posterUrl: "",
                slug: "",
                idMovie: "");
        final List<comingSoon?> listComing = state.comingData!.listComingSoon;
        final List<String> urlImage = listComing.map((e) {
          return '${dotenv.env['API_LOAD_IMAGE']}${e!.image}';
        }).toList();

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Row(
                  children: [
                    Text(
                      'Đang',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    ),
                    Text(
                      ' xem....',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
              ),
              //Continous
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Container(
                  height: size.height * 0.235,
                  width: size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: isAuthen
                              ? CachedNetworkImage(
                                  imageUrl:
                                      '${dotenv.env['API_LOAD_IMAGE']}${saveTimeEntity.posterUrl}',
                                  placeholder: (context, url) => Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.5),
                                      ),
                                  errorWidget: (context, url, error) {
                                    return const Center(
                                      child: Icon(Icons.error),
                                    );
                                  },
                                  fit: BoxFit.fill,
                                  width: size.width > 600
                                      ? size.width * 0.5
                                      : size.width)
                              : Image.asset(
                                  'assets/images/default_image.png',
                                  fit: BoxFit.cover,
                                  width: size.width > 600
                                      ? size.width * 0.5
                                      : size.width,
                                ),
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          left: size.width > 600 ? size.width * 0.25 : 10,
                          child: GestureDetector(
                            onTap: () =>
                                isAuthen ? watchMovie(saveTimeEntity) : null,
                            child: Container(
                              height: size.width > 600
                                  ? size.height * 0.08 + 2
                                  : size.height * 0.076,
                              width: size.width > 600
                                  ? size.width * 0.2
                                  : size.width * 0.5,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.6),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.play_circle_filled_sharp,
                                    size: 50,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Xem tiếp',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.65),
                                        ),
                                      ),
                                      Text(
                                        isAuthen ? 'Sẵn sàng' : 'Không tồn tại',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  'Sắp chiếu...',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              //Coming Soon
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CarouselSlider.builder(
                    itemCount: urlImage.length,
                    itemBuilder: (context, index, realIndex) {
                      final imagelink = urlImage[index];
                      return buildImage(
                          imagelink,
                          index,
                          listComing[index]!.nameMovie.trim(),
                          listComing[index]!.voteAverage.toStringAsFixed(1),
                          () => onTapMovie(
                              listComing[index]!.slug, listComing[index]!.id));
                    },
                    options: CarouselOptions(
                        height: size.height * 0.37,
                        viewportFraction: size.width > 600 ? 0.5 : 0.8,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.2)),
              )
            ],
          ),
        );
      }
      if (state is getFail) {
        return const Errorscreen();
      } else {
        return const loadingIndicator();
      }
    }));
  }

  Widget buildImage(String urlImage, int index, String name, String rating,
      Function()? onTap) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          //image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: urlImage,
                placeholder: (context, url) => Container(
                  height: size.height * 0.36,
                  width:
                      size.width > 600 ? size.width * 0.5 : size.width * 0.688,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
                fit: BoxFit.cover,
                height: size.height * 0.38 + 10,
                width: size.width > 600 ? size.width * 0.5 : size.width * 0.688,
              ),
            ),
          ),

          // Name
          Positioned(
              bottom: 10,
              left: size.width > 600 ? size.width * 0.05 - 11 : 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                    height: size.height * 0.08,
                    width:
                        size.width > 600 ? size.width * 0.4 : size.width * 0.6,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Text(name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis)),
                    )),
              )),

          // Rate
          Positioned(
              top: 10,
              right: 20,
              child: Container(
                  height: size.width > 600
                      ? size.height * 0.057 + 10
                      : size.height * 0.057,
                  width:
                      size.width > 600 ? size.width * 0.1 : size.width * 0.22,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.6),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'IMDB',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.yellow,
                            size: 26,
                          ),
                          Text(rating.toString(),
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w600))
                        ],
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}
