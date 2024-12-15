class Movieofcategories {
  String id;
  String name;
  String slug;
  String posterUrl;

  Movieofcategories(
      {required this.id,
      required this.name,
      required this.slug,
      required this.posterUrl});

  factory Movieofcategories.fromJson(Map<String, dynamic> json) {
    return Movieofcategories(
        id: json['_id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        posterUrl: json['poster_url']);
  }
}

class ListMovieOfCategories {
  List<Movieofcategories> listMovieOfCategories;

  ListMovieOfCategories({required this.listMovieOfCategories});

  factory ListMovieOfCategories.fromJson(Map<String, dynamic> json) {
    return ListMovieOfCategories(
        listMovieOfCategories: (json['items'] as List<dynamic>)
            .map((e) => Movieofcategories.fromJson(e))
            .toList());
  }
}
