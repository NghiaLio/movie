import '../../../Auth/Domain/Entities/UserModel.dart';

class ProfileUser extends AppUser {
  String urlImage;
  ProfileUser(
      {required super.userName,
      required super.email,
      required super.uid,
      required this.urlImage});

  ProfileUser copyWith({String? newUrlImage}) {
    return ProfileUser(
        userName: userName,
        email: email,
        uid: uid,
        urlImage: newUrlImage ?? urlImage);
  }

  //convert to json
  @override
  Map<String, dynamic> toJson() =>
      {'userName': userName, 'uid': uid, 'email': email, 'urlImage': urlImage};

  // convert from json
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        userName: json['userName'] ?? '',
        email: json['email'] ?? '',
        uid: json['uid'] ?? "",
        urlImage: json['urlImage'] ?? '');
  }
}
