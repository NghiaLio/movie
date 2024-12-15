import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../Infor_of_Movie/Presentation/screen/movieInfoScreen.dart';
import '../../../Domain/Entities/MovieOfCategories.dart';
import '../../../../SearchMovie/presentation/screen/searchView.dart';

class viewMovie extends StatefulWidget {
  List<Tab> tabTitle;
  List<ListMovieOfCategories?> list;
  viewMovie({super.key, required this.tabTitle, required this.list});

  @override
  State<viewMovie> createState() => _viewMovieState();
}

class _viewMovieState extends State<viewMovie> {
  //search
  void pushSearch() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Searchview()));
  }

  //pushToInfo
  void pushToInfo(String slug, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => Movieinfoscreen(
            slugMovie: slug,
            idMovie: id,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 0,
      length: widget.tabTitle.length,
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Header
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Danh sách phim..'),
                                  Text(
                                    'và tìm kiếm..',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //SearchBar
                          TextField(
                            onTap: pushSearch,
                            readOnly: true,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.8)),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.search,
                                  size: 28,
                                ),
                              ),
                              hintText: 'Tìm kiếm..',
                              filled: true,
                              fillColor: Color.fromRGBO(187, 187, 187, 0.1),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ];
                },
                //ListOfCategories
                body: Wrap(
                  children: [
                    //Categories
                    TabBar(
                      indicatorPadding: const EdgeInsets.only(right: 50),
                      indicatorColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      labelColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                      tabAlignment: TabAlignment.start,
                      dividerHeight: 0,
                      isScrollable: true,
                      tabs: widget.tabTitle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: size.height * 0.8 - 20,
                        child: TabBarView(
                          children: [
                            for (int i = 0; i < widget.tabTitle.length; i++)
                              itemMovie(
                                widget.list[i]!.listMovieOfCategories,
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  Widget itemMovie(
    List<Movieofcategories> movieOfCategories,
  ) {
    final size = MediaQuery.of(context).size;

    return MasonryGridView.builder(
        itemCount: movieOfCategories.length,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size.width > 600 ? 3 : 2),
        itemBuilder: (context, index) => GestureDetector(
              onTap: () => pushToInfo(
                  movieOfCategories[index].slug, movieOfCategories[index].id),
              child: Column(
                children: [
                  //image
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: CachedNetworkImage(
                      placeholder: (context, text) => const Center(
                        child: Text('loading...'),
                      ),
                      fit: BoxFit.fill,
                      imageUrl:
                          '${dotenv.env['API_LOAD_IMAGE']}${movieOfCategories[index].posterUrl}',
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
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //name
                  Text(
                    movieOfCategories[index].name,
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
            ));
  }
}
