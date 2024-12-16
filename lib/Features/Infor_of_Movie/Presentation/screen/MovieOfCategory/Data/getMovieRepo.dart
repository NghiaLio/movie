import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../Domain/Entities/Categories.dart';
import '../Domain/Entities/MovieOfCategories.dart';
import '../Domain/Repo/movieCategoris.dart';
import 'package:http/http.dart' as http;

class getMovieRepo implements movieCategoriesRepo {
  @override
  Future<ListCategories?> getListCategories() async {
    // có thể dùng statuscode
    try {
      final Url = '${dotenv.env['DOMAIN_API']}the-loai';
      final response = await http.get(Uri.parse(Url));
      final bodyDecode = jsonDecode(response.body);
      ListCategories listCategories =
          ListCategories.fromJson(bodyDecode['data']);
      return listCategories;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ListMovieOfCategories?> getListMovieCategories(String slug) async {
    final Url = '${dotenv.env['DOMAIN_API']}the-loai/$slug';
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      final bodyDecode = jsonDecode(response.body);
      ListMovieOfCategories listMovieOfCategories =
          ListMovieOfCategories.fromJson(bodyDecode['data']);
      return listMovieOfCategories;
    } else {
      return null;
    }
  }
}
