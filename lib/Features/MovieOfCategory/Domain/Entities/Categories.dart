class Categories {
  String id;
  String name;
  String slug;

  Categories({required this.id, required this.name, required this.slug});

  //fromjson
  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        id: json['_id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String);
  }
}

class ListCategories {
  List<Categories> listCategories;

  ListCategories({required this.listCategories});
  //fromJson
  factory ListCategories.fromJson(Map<String, dynamic> json) {
    return ListCategories(
        listCategories: (json['items'] as List<dynamic>)
            .map((e) => Categories.fromJson(e))
            .toList());
  }
}
