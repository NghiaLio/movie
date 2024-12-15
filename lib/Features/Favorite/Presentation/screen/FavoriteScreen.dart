import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Components/Loading.dart';
import '../Cubit/favoriteCubit.dart';
import '../Cubit/favoriteSate.dart';
import '../../domain/Entities/Favorite.dart';

import '../../../Infor_of_Movie/Presentation/screen/movieInfoScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Favoritescreen extends StatefulWidget {
  final String uid;
  const Favoritescreen({super.key, required this.uid});

  @override
  State<Favoritescreen> createState() => _FavoritescreenState();
}

class _FavoritescreenState extends State<Favoritescreen> {
  bool isEditItem = false;

  late List<bool> checkItem;

  @override
  void initState() {
    context.read<Favoritecubit>().getFavoriteMovie(widget.uid);
    final dataFavorite = context.read<Favoritecubit>().listFavotite;
    if(dataFavorite != null){
      final listMovie =dataFavorite.ListFavoriteMovie;
      checkItem = listMovie.map((e) => false).toList();

    }
    super.initState();
  }

  //back
  void back() {
    Navigator.pop(context);
  }

  // nhan giu item
  void onLongPress(int index) {
    setState(() {
      isEditItem = checkItem[index] = true;
    });
  }

  // cancle edit
  void cancleEdit() {
    setState(() {
      isEditItem = false;
      checkItem = checkItem.map((e) => false).toList();
    });
  }

  //selected all
  void selectedAll() {
    setState(() {
      isEditItem = true;
      checkItem = checkItem.map((e) => true).toList();
    });
  }

  void tapToMovieInfo(String slug, String idMovie) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Movieinfoscreen(
                  slugMovie: slug,
                  idMovie: idMovie,
                )));
  }

  void onDelete(List<FavoriteMovie> listMovie) async {
    // index of checkbox
    List<int> indexCheked = [];
    checkItem.asMap().forEach(
      (key, value) {
        if (value) {
          indexCheked.add(key);
        }
      },
    );

    for (var e in indexCheked) {
      await context
          .read<Favoritecubit>()
          .deleteMovie(widget.uid, listMovie[e].id);
    }

    cancleEdit();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<Favoritecubit, Favoritesate>(builder: (context, state) {
      print(state);
      if (state is loadedFavorite) {
        final dataState = state.listFavorite ?? ListFavorite(ListFavoriteMovie: []);
        final listFavorite = dataState.ListFavoriteMovie;
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: back,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              title: const Text('Phim yêu thích'),
              actions: [
                isEditItem
                    ? GestureDetector(
                        onTap: cancleEdit,
                        child: const Text(
                          'Hủy',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Container(),
                PopupMenuButton(
                  iconSize: 28,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: '',
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
                      child: Text(
                        'Chọn tất cả',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                  onSelected: (value) => selectedAll(),
                )
              ],
            ),
            body: listFavorite.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      children: [
                        ListView.builder(
                            itemCount: listFavorite.length,
                            itemBuilder: (context, index) =>
                                itemMovie(index, listFavorite[index])),
                        AnimatedPositioned(
                            bottom: !checkItem.contains(true)
                                ? -size.height * 0.06
                                : 0,
                            duration: const Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: () => onDelete(listFavorite),
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height * 0.06,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: size.width,
                                child: Text(
                                  'Xóa khỏi danh sách yêu thích',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      fontSize: 20,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                    'Không có phim yêu thích',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )));
      } else {
        return const loadingIndicator();
      }
    });
  }

  Widget itemMovie(int index, FavoriteMovie movie) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        SizedBox(
          height: size.height * 0.2,
          width: size.width * 0.2 + 10,
          child: Checkbox(
              activeColor: Theme.of(context).colorScheme.secondaryContainer,
              value: checkItem[index],
              onChanged: (value) {
                setState(() {
                  checkItem[index] = value!;
                });
              }),
        ),
        AnimatedPositioned(
          left: isEditItem ? size.width * 0.2 + 10 : 0,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onLongPress: () => onLongPress(index),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => tapToMovieInfo(movie.slug, movie.id),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${dotenv.env['API_LOAD_IMAGE']}${movie.posterUrl}',
                        placeholder: (context, text) => const Center(
                          child: Text('loading...'),
                        ),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              size: 30,
                            ),
                          );
                        },
                        height: size.height * 0.2,
                        width: size.width * 0.3 + 10,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () => tapToMovieInfo(movie.slug, movie.id),
                    child: SizedBox(
                      width: isEditItem
                          ? size.width * 0.5 - 20
                          : size.width * 0.6 - 20,
                      child: Text(
                        movie.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
