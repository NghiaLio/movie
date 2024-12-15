import 'episode.dart';
import 'newCategories.dart';

class movie {
  String id;
  String nameTitle;
  String slug;
  String quality;
  String timeOn;
  double vote_average;
  String poster_url;
  String releaseDate;
  List<Newcategories> genre;
  String describe;
  String trailer_url;
  String type;
  String episode_current;
  String lang;
  List<episode> listEpisode;

  movie(
      {required this.id,
      required this.nameTitle,
      required this.slug,
      required this.quality,
      required this.timeOn,
      required this.describe,
      required this.trailer_url,
      required this.genre,
      required this.poster_url,
      required this.releaseDate,
      required this.type,
      required this.vote_average,
      required this.episode_current,
      required this.lang,
      required this.listEpisode});

  //fromJson

  factory movie.fromJson(Map<String, dynamic> json) {
    return movie(
        id: json['_id'] as String,
        nameTitle: json['name'] as String,
        slug: json['slug'] as String,
        quality: json['quality'] as String,
        timeOn: json['time'] as String,
        describe: json['content'] as String,
        genre: (json['category'] as List<dynamic>)
            .map((e) => Newcategories.fromJson(e))
            .toList(),
        poster_url: json['poster_url'] as String,
        releaseDate: json['created']['time'] as String,
        type: json['type'] as String,
        trailer_url: json['trailer_url'] as String,
        vote_average: (json['tmdb']['vote_average'] as num).toDouble(),
        episode_current: json['episode_current'] as String,
        lang: json['lang'] as String,
        listEpisode: ((json['episodes'] as List<dynamic>)[0]['server_data']
                as List<dynamic>)
            .map((e) => episode.fromJson(e))
            .toList());
  }


  //to json 
  Map<String, dynamic> toJson() =>{
    'id': id,
    'nameTitle': nameTitle,
    'slug': slug,
    'poster_url': poster_url
  };
}
