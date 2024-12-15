import 'package:cloud_firestore/cloud_firestore.dart';
import '../Domain/Entities/Profile.dart';
import '../Domain/Repo/UserProfileRepo.dart';

class DataRepoProfile implements profileRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchProfileUser(String uid) async {
    try {
      // get user document
      final userDoc = await firebaseFirestore.collection('User').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return ProfileUser(
              userName: userData['userName'],
              email: userData['email'],
              uid: uid,
              urlImage: userData['urlImage'] ?? '');
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> updateProfileUser(String name, String uid) async {
    final code = await firebaseFirestore
          .collection('User')
          .doc(uid)
          .update({'userName' : name})
          .then((value)=> 200)
          .catchError((e)=> 404);

    return code;
  }

  
}
