
import '../Entities/Profile.dart';

abstract class profileRepo{
  Future<ProfileUser?> fetchProfileUser(String uid);
  Future<void> updateProfileUser(String name, String uid);
}