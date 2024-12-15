import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../WatchMovie/Domain/SaveTimeEntity.dart';
import '../Domain/Entities/ComingModel.dart';
import '../Domain/Reppo/homeRepo.dart';
import 'package:http/http.dart' as http;

class getDataComingSoonRepo implements HomeRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ModelComingSoon?> getDataComingSoon() async {
    try {
      final Url = '${dotenv.env['DOMAIN_API']}danh-sach/phim-sap-chieu';
      final response = await http.get(Uri.parse(Url));
      final body = response.body;
      final deCodeJson = jsonDecode(body);
      ModelComingSoon dataComing = ModelComingSoon.fromJson(deCodeJson['data']);
      return dataComing;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<SaveTimeEntity?> getContinousMovie(String? uid) async {
    try {
      final response = await firebaseFirestore
          .collection('ContinousWatching')
          .doc(uid)
          .get();
      if (response.exists) {
        return SaveTimeEntity.fromJson(response.data()!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
