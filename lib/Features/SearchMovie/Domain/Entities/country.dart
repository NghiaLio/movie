import '../../../MovieOfCategory/Domain/Entities/Categories.dart';

class country extends Categories {
  country({required super.id, required super.name, required super.slug});

  factory country.fromJson(Map<String, dynamic> json) {
    return country(id: json['_id'], name: json['name'], slug: json['slug']);
  }
}

class listCountry {
  List<country> list_Country;
  listCountry({required this.list_Country});

  factory listCountry.fromJson(Map<String, dynamic> json) {
    return listCountry(
        list_Country: (json['items'] as List<dynamic>)
            .map((e) => country.fromJson(e))
            .toList());
  }
}
