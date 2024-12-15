import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../Domain/Entities/country.dart';
import '../Domain/Entities/searchMovie.dart';
import '../Domain/Repo/searchRepo.dart';
import 'package:http/http.dart' as http;

class Getdatasearchrepo implements searchRepo {
  @override
  Future<listCountry?> getListCountry() async {
    final url = '${dotenv.env['DOMAIN_API']}quoc-gia';
    final response_1 = await http.get(Uri.parse(url));
    if (response_1.statusCode == 200) {
      final bodyDecode_1 = jsonDecode(response_1.body);
      listCountry listData_1 = listCountry.fromJson(bodyDecode_1['data']);
      return listData_1;
    } else {
      return null;
    }
  }

  @override
  Future<listMovieofSearch?> getListMovieofCountry(String slugCountry) async {
    final url = '${dotenv.env['DOMAIN_API']}quoc-gia/$slugCountry';
    final response_2 = await http.get(Uri.parse(url));
    if (response_2.statusCode == 200) {
      final bodyDecode_2 = jsonDecode(response_2.body);
      listMovieofSearch listData_2 =
          listMovieofSearch.fromJson(bodyDecode_2['data']);
      return listData_2;
    } else {
      return null;
    }
  }

  @override
  Future<listMovieofSearch?> getListMovieofSearch(String slugSuggest) async {
    final url = '${dotenv.env['DOMAIN_API']}danh-sach/$slugSuggest';
    final response_3 = await http.get(Uri.parse(url));
    if (response_3.statusCode == 200) {
      final bodyDecode_3 = jsonDecode(response_3.body);
      listMovieofSearch listData_3 =
          listMovieofSearch.fromJson(bodyDecode_3['data']);
      return listData_3;
    } else {
      return null;
    }
  }

  @override
  Future<listMovieofSearch?> getListMovieofKeyword(String keyword) async {
    final url = '${dotenv.env['DOMAIN_API']}tim-kiem?keyword=$keyword';
    final response_4 = await http.get(Uri.parse(url));
    if (response_4.statusCode == 200) {
      final bodyDecode_4 = jsonDecode(response_4.body);
      listMovieofSearch listData_4 =
          listMovieofSearch.fromJson(bodyDecode_4['data']);
          print('object');
      return listData_4;
    } else {
      return null;
    }
  }
}
