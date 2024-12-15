// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Domain/SaveTimeEntity.dart';

class TimeMovie {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TimeMovie();

  Future<void> saveTimePause(String uid, SaveTimeEntity saveTimePause) async {
    await firebaseFirestore
        .collection('ContinousWatching')
        .doc(uid)
        .set(saveTimePause.toJson())
        .then((onValue) => print('succes'))
        .catchError((onError) => print(onError));
  }

}
