import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../Domain/Entities/movie.dart';
import '../Domain/Repo/movierepo.dart';
import 'package:http/http.dart' as http;

class Getdatamovie implements Movierepo {
  @override
  Future<movie?> getMovieData(String slug) async {
    final url = '${dotenv.env['DOMAIN_API']}phim/$slug';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bodyDecode = jsonDecode(response.body);
      final x = bodyDecode['data']['item'];
      movie datamovie = movie.fromJson(x);
      return datamovie;
    } else {
      return null;
    }
  }
}
