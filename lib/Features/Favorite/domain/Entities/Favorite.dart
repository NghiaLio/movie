import '../../../MovieOfCategory/Domain/Entities/MovieOfCategories.dart';

class FavoriteMovie extends Movieofcategories {
  FavoriteMovie(
      {required super.id,
      required super.name,
      required super.slug,
      required super.posterUrl});

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) {
    return FavoriteMovie(
        id: json['id'] as String,
        name: json['nameTitle'] as String,
        slug: json['slug'] as String,
        posterUrl: json['poster_url']);
  }
}

class ListFavorite {
  List<FavoriteMovie> ListFavoriteMovie;
  ListFavorite({required this.ListFavoriteMovie});

  factory ListFavorite.fromJson(Map<String, dynamic> json) {
    return ListFavorite(
        ListFavoriteMovie: (json['favorite'] as List<dynamic>)
            .map((e) => FavoriteMovie.fromJson(e))
            .toList());
  }
}
