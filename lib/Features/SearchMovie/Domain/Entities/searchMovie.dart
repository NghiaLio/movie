import '../../../MovieOfCategory/Domain/Entities/MovieOfCategories.dart';

class Searchmovie extends Movieofcategories {
  Searchmovie(
      {required super.id,
      required super.name,
      required super.slug,
      required super.posterUrl});

  factory Searchmovie.fromJson(Map<String, dynamic> json) {
    return Searchmovie(
        id: json['_id'],
        name: json['name'],
        slug: json['slug'],
        posterUrl: json['poster_url']);
  }
}

class listMovieofSearch {
  List<Searchmovie> listSearch;
  listMovieofSearch({required this.listSearch});

  factory listMovieofSearch.fromJson(Map<String, dynamic> json) {
    return listMovieofSearch(
        listSearch: (json['items'] as List<dynamic>)
            .map((e) => Searchmovie.fromJson(e))
            .toList());
  }
}
