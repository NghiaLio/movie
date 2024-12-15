// ignore: file_names
class comingSoon{
  String id;
  String nameMovie;
  String image;
  String slug;
  double voteAverage;

  comingSoon({required this.nameMovie,required this.image,required this.id, required this.slug, required this.voteAverage });

  //fromJson
  factory comingSoon.fromJson(Map<String, dynamic> json){
    return comingSoon(
      nameMovie:json['name'] as String , 
      image: json['poster_url'] as String,
      id: json['_id'] as String, 
      slug: json['slug'] as String, 
      voteAverage: (json['tmdb']['vote_average'] as num).toDouble()
    );
  }
}

class ModelComingSoon{
  List<comingSoon> listComingSoon;

  ModelComingSoon({required this.listComingSoon});

  factory ModelComingSoon.fromJson(Map<String, dynamic> json){
    return ModelComingSoon(
      listComingSoon: (json['items'] as List<dynamic>).map(
        (e)=> comingSoon.fromJson(e as Map<String, dynamic>)
      ).toList()
    );
  }
}