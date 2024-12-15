// ignore_for_file: file_names

class AppUser{
  String userName;
  String email;
  String uid;

  AppUser({required this.userName, required this.email, required this.uid});

  // user to Json
  Map<String, dynamic> toJson() =>{
    'userName' : userName,
    'email': email,
    'uid': uid
  };

  // Json to user
  factory AppUser.fromJson(Map<String, dynamic> json){
    return AppUser(
      userName: json['userName'] as String, 
      email: json['email'] as String, 
      uid: json['uid'] as String);
  }
}