import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Searchlayout extends StatefulWidget {
  List<dynamic> listMoviebySearch;
  Function(String slug, String id) tapToMovieInfo;

  Searchlayout({super.key, required this.listMoviebySearch, required this.tapToMovieInfo});

  @override
  State<Searchlayout> createState() => _SearchlayoutState();
}

class _SearchlayoutState extends State<Searchlayout> {
  @override
  Widget build(BuildContext context) {
    //list movie
    return SizedBox(
      child: ListView.builder(
          itemCount: widget.listMoviebySearch.length,
          itemBuilder: (context, index) => itemMovie(
              widget.listMoviebySearch[index].posterUrl,
              widget.listMoviebySearch[index].name,
              widget.listMoviebySearch[index].slug,
              widget.listMoviebySearch[index].id
              )),
    );
  }

  Widget itemMovie(String imageUrl, String name, String slug, String id) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap:()=> widget.tapToMovieInfo(slug, id),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: '${dotenv.env['API_LOAD_IMAGE']}$imageUrl',
                placeholder: (context, text) => const Center(
                  child: Text('loading...'),
                ),
                errorWidget: (context, text, ob) {
                  return Container(
                    height: 100,
                    width: 200,
                    color:
                        Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    child: Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.secondaryContainer,
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
            onTap:()=> widget.tapToMovieInfo(slug,id ),
            child: SizedBox(
              width: size.width * 0.6 - 20,
              child: Text(
                name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
