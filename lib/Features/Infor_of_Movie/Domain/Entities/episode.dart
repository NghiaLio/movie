class episode {
  String name;
  String slug;
  String file_name;
  String link_m3u8;

  episode(
      {required this.file_name,
      required this.link_m3u8,
      required this.name,
      required this.slug});

  //fromjson

  factory episode.fromJson(Map<String, dynamic> json) {
    return episode(
        file_name: json['file_name'] ?? "",
        link_m3u8: json['link_m3u8'] ?? "",
        name: json['name'] ?? "",
        slug: json['slug'] ?? "");
  }
}
