import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import '../../../Components/ErrorScreen.dart';
import '../../../Components/Loading.dart';
import '../../../Auth/Presentation/Cubit/authCubit.dart';
import '../../../Auth/Presentation/Cubit/auth_States.dart';
import '../../../Auth/Presentation/Screen/auth.dart';
import "../../../Favorite/Presentation/Cubit/favoriteCubit.dart";
import '../../Domain/Entities/movie.dart';
import '../../Domain/Entities/newCategories.dart';
import '../Cubit/movieInfoCubit.dart';
import '../Cubit/movieInfoState.dart';
import '../../../Components/DialogLogin.dart';
import '../../../WatchMovie/Presentation/watchmovie.dart';

class Movieinfoscreen extends StatefulWidget {
  String idMovie;
  String slugMovie;
  final String? previousSlugMovie;
  Movieinfoscreen(
      {super.key,
      required this.slugMovie,
      this.previousSlugMovie,
      required this.idMovie});

  @override
  State<Movieinfoscreen> createState() => _MovieinfoscreenState();
}

class _MovieinfoscreenState extends State<Movieinfoscreen> {
  int currentEpisode = 1;
  late bool isAuthen;
  late String uid;
  late bool isFavorite;

  //tapToWatch
  void tapToWatch(String movieUrl, String nameEpisode, String poster_url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Watchmovie(
                  movieUrl: movieUrl,
                  nameEpisode: nameEpisode,
                  posterUrl: poster_url,
                  uid: uid,
                  slug: widget.slugMovie,
                  idMovie: widget.idMovie,
                ),                
                ));
  }

  // show dialog login
  void showLoginDialog() {
    showDialog(
        context: context,
        builder: (context) => Dialoglogin(
              onLoginTap: tapToLogin,
            ));
  }

  //tap to login
  void tapToLogin() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => const authScreen(isLoginError: false)));
  }

  //selectEpisode
  void selectEpisode(
      int index, String urlMovie, nameEpisode, String poster_url) {
    setState(() {
      currentEpisode = index + 1;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Watchmovie(
                  movieUrl: urlMovie,
                  nameEpisode: nameEpisode,
                  posterUrl: poster_url,
                  uid: uid,
                  slug: widget.slugMovie,
                  idMovie: widget.idMovie,
                )));
  }

  //information of another movie
  void tapAnotherMovie(String slugMovie, String id) async {
    final resultSlug = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Movieinfoscreen(
                  idMovie: id,
                  slugMovie: slugMovie,
                  previousSlugMovie: widget.slugMovie,
                )));
    if (resultSlug != null) {
      context.read<MovieinfoCubit>().getMovieInfo(resultSlug);
    }
  }

  //popToHome
  void popToHome() {
    Navigator.pop(context, widget.previousSlugMovie);
  }

  //convertTime
  String parseTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  //convert list categorige to String
  String genre(List<Newcategories> categorige) {
    String result = categorige.map((e) => e.name).join(',');
    return result;
  }

  // on like button
  Future<bool> onLikeButtonTapped(
      bool isLiked, movie favoriteMovie, String uid) async {
    if (isLiked == false) {
      await context.read<MovieinfoCubit>().setFavoriteMovie(favoriteMovie, uid);
      await context.read<Favoritecubit>().getFavoriteMovie(uid);
    } else {
      await context.read<Favoritecubit>().deleteMovie(uid, widget.idMovie);
    }
    return !isLiked;
  }

  Future<bool> onUnLikeButtonTapped(bool isLiked) async {
    showLoginDialog();
    return isLiked;
  }

  // check favorite
  bool checkFavorite() {
    final data = context.read<Favoritecubit>().listFavotite;
    if (data != null) {
      final listMovieOfFavorite = data.ListFavoriteMovie;
      final exists = listMovieOfFavorite.any((e) => e.id == widget.idMovie);
      return exists;
    } else {
      return false;
    }
  }

  // tap Trailer
  void onTapTrailler() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      'Trailer chưa được cập nhật ',
      style: TextStyle(fontSize: 16),
    )));
  }

  @override
  void initState() {
    context.read<MovieinfoCubit>().getMovieInfo(widget.slugMovie);
    //check auth

    final currentAuthState = context.read<Authcubit>().state;
    if (currentAuthState is UnAuthenticated) {
      setState(() {
        isAuthen = false;
        isFavorite = false;
      });
    }
    if (currentAuthState is Authenticated) {
      setState(() {
        isAuthen = true;
        uid = currentAuthState.user!.uid;
        isFavorite = checkFavorite();
      });
    }

    // //check favorite
    // setState(() {
    //   isFavorite = checkFavorite();
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<Authcubit, AuthStates>(
      listener: (context, stateAuth) {
        if (stateAuth is Authenticated) {
          setState(() {
            isAuthen = true;
            uid = stateAuth.user!.uid;
            isFavorite = checkFavorite();
          });
        }
        if (stateAuth is UnAuthenticated) {
          setState(() {
            isAuthen = false;
            isFavorite = false;
          });
        }
      },
      child: BlocBuilder<MovieinfoCubit, MovieInfoState>(
          builder: (context, state) {
        print(state);
        if (state is loadedMovieInfo) {
          movie? movieInfo = state.movieInfo;
          final listAnotherMovie = state.listMovieOfCategories;
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //poster
                  SizedBox(
                    height: size.height * 0.354,
                    width: size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              '${dotenv.env['API_LOAD_IMAGE']}${movieInfo!.poster_url}',
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                            top: 50,
                            left: 30,
                            child: IconButton(
                                onPressed: popToHome,
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 30,
                                ))),
                        Positioned(
                            top: 50,
                            right: 30,
                            child: LikeButton(
                                size: 40,
                                isLiked: isFavorite,
                                likeBuilder: (isTapped) {
                                  return Icon(
                                    Icons.favorite,
                                    size: 40,
                                    color: isTapped
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                  );
                                },
                                onTap: (bool isLiked) async => isAuthen
                                    ? onLikeButtonTapped(
                                        isLiked, movieInfo, uid)
                                    : onUnLikeButtonTapped(isLiked))),
                        GestureDetector(
                          onTap: () => isAuthen
                              ? tapToWatch(
                                  movieInfo.listEpisode[0].link_m3u8,
                                  '${movieInfo.nameTitle}: Tập 1',
                                  movieInfo.poster_url)
                              : showLoginDialog(),
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.6),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.play_arrow,
                                size: 50,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //Name and quality
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: size.width * 0.7 - 25,
                            child: Text(
                              movieInfo.nameTitle,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                              // width: size.width * 0.2,
                              child: DefaultTextStyle(
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(153, 69, 68, 68),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(movieInfo.quality),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(153, 69, 68, 68),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(movieInfo.lang),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  //time and voteAverage
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: DefaultTextStyle(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.av_timer_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(movieInfo.timeOn)
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star_purple500_sharp,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('${movieInfo.vote_average}(TMDB)')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Date and categorige
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10.0),
                    child: Column(
                      children: [
                        const DefaultTextStyle(
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            child: Row(
                              children: [
                                Text('Phát hành'),
                                SizedBox(
                                  width: 80,
                                ),
                                Text('Thể loại')
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              parseTime(movieInfo.releaseDate),
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            const SizedBox(
                              width: 80,
                            ),
                            SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                genre(movieInfo.genre),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //episode
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              movieInfo.episode_current,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: onTapTrailler,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 69, 67, 67),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Text(
                                  'Trailer',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tập',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              height: movieInfo.listEpisode.length > 5
                                  ? (size.width > 600
                                      ? size.height * 0.15
                                      : size.height * 0.1 - 5)
                                  : size.height * 0.05,
                              width: size.width > 600
                                  ? size.width * 0.9 + 30
                                  : size.width * 0.8 + 10,
                              child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: movieInfo.listEpisode.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 16 / 9,
                                    crossAxisCount: size.width > 600 ? 12 : 5,
                                  ),
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () => isAuthen
                                            ? selectEpisode(
                                                index,
                                                movieInfo.listEpisode[index]
                                                    .link_m3u8,
                                                '${movieInfo.nameTitle}: Tập ${index + 1}',
                                                movieInfo.poster_url)
                                            : showLoginDialog(),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 69, 67, 67),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                                color: (index + 1) ==
                                                        currentEpisode
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondaryContainer
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  //describe
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mô tả',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ReadMoreText(
                          movieInfo.describe,
                          trimMode: TrimMode.Line,
                          trimLines: 2,
                          colorClickableText:
                              Theme.of(context).colorScheme.primary,
                          trimCollapsedText: 'Mở rộng',
                          trimExpandedText: 'Thu gọn',
                          moreStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary),
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                  ),
                  //other movie
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phim khác..',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: size.height * 0.25,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listAnotherMovie.length,
                              itemBuilder: (context, index) => itemMovieOther(
                                  listAnotherMovie[index]!.name,
                                  listAnotherMovie[index]!.posterUrl,
                                  () => tapAnotherMovie(
                                      listAnotherMovie[index]!.slug,
                                      listAnotherMovie[index]!.id))),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
        if (state is errorMovieInfo) {
          return const Errorscreen();
        } else {
          return const loadingIndicator();
        }
      }),
    );
  }

  Widget itemMovieOther(String name, String urlImage, Function()? onTap) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: size.height * 0.18,
          width: size.width > 600 ? size.width * 0.2 : size.width * 0.38,
          child: Column(
            children: [
              //image
              SizedBox(
                height:
                    size.width > 600 ? size.height * 0.2 : size.height * 0.13,
                width: size.width > 600 ? size.width * 0.2 : null,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: '${dotenv.env['API_LOAD_IMAGE']}$urlImage',
                    placeholder: (context, text) =>
                        const Center(child: Text('loading....')),
                    errorWidget: (context, text, ob) {
                      return Container(
                        height: 100,
                        width: 200,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                        child: Icon(
                          Icons.error,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //name
              Text(
                name,
                style: const TextStyle(
                    fontSize: 16, overflow: TextOverflow.ellipsis),
                maxLines: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
