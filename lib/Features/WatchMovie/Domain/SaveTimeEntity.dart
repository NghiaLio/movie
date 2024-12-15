

class SaveTimeEntity {
  String uid;
  String time;
  String movieUrl;
  String posterUrl;
  String nameEpisoda;
  String slug;
  String idMovie;
  SaveTimeEntity(
      {required this.uid,
        required this.time,
      required this.movieUrl,
      required this.nameEpisoda,
      required this.posterUrl,
      required this.idMovie,
      required this.slug
     });

  factory SaveTimeEntity.fromJson(Map<String, dynamic> json) {
    return SaveTimeEntity(
      uid: json['uid'],
        movieUrl: json['movieUrl'],
        nameEpisoda: json['nameEpisoda'],
        posterUrl: json['posterUrl'],
        slug: json['slug'],
        idMovie: json['idMovie'],
        time: json['time']);
  }

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'movieUrl':movieUrl,
    'nameEpisoda':nameEpisoda,
    'posterUrl':posterUrl,
    'time': time,
    'slug': slug,
    'idMovie': idMovie
  };
}
