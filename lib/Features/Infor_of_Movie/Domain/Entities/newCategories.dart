class Newcategories {
  String id;
  String name;
  String slug;

  Newcategories({required this.id, required this.name, required this.slug});

  //fromjson
  factory Newcategories.fromJson(Map<String, dynamic> json) {
    return Newcategories(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String);
  }
}