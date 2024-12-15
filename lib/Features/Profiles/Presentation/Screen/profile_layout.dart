import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Auth/Presentation/Cubit/authCubit.dart';
import '../../../Auth/Presentation/Screen/auth.dart';
import '../../../Favorite/Presentation/screen/FavoriteScreen.dart';
import '../../../Components/DialogLogin.dart';
import '../../Domain/Entities/Profile.dart';
import 'Components/Person_information.dart';

class ProfileLayout extends StatefulWidget {
  Function()? clickAuth;
  ProfileUser? profileUser;
  bool isAuthen;
  ProfileLayout(
      {super.key,
      required this.clickAuth,
      required this.isAuthen,
      this.profileUser});

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  //log out
  void logOut() {
    context.read<Authcubit>().logOut();
  }

  // show dialog login
  void showLoginDialog() {
    showDialog(
        context: context,
        builder: (context) => Dialoglogin(
              onLoginTap: tapToLogin,
            ));
  }

  //tap to login
  void tapToLogin() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => const authScreen(isLoginError: false)));
  }

  void pushPersonInfor() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => PersonInformation(
                  profileUser: widget.profileUser,
                  isAuthen: widget.isAuthen,
                )));
  }

  //push favorite screen
  void pushFavoriteScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Favoritescreen(uid: widget.profileUser!.uid)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Avatar and name
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                alignment: Alignment.bottomLeft,
                height: size.height * 0.3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/themovie.png'))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Avatar
                    Container(
                      height: 120,
                      width: 120,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/Unknown_person.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //login button or TextName
                    !widget.isAuthen
                        ? buttonAction('Đăng nhập', widget.clickAuth)
                        : Container(
                            alignment: Alignment.bottomLeft,
                            width: size.width * 0.6,
                            height: size.height * 0.1 + 20,
                            child: Text(
                              'Xin chào\n${widget.profileUser!.userName}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            //Divider
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 2,
            ),
            //Favorite movie
            itemSelected(Icons.favorite, 'Phim yêu thích',
                widget.isAuthen ? pushFavoriteScreen : showLoginDialog),

            //User Information
            itemSelected(
                Icons.person_3_sharp, 'Thông tin tài khoản', pushPersonInfor),

            //Setting
            itemSelected(Icons.settings, 'Cài Đặt', null),

            //Logout button
            widget.isAuthen
                ? itemSelected(Icons.login_outlined, 'Đăng xuất', logOut)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buttonAction(String text, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primaryContainer,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget itemSelected(IconData icon, String text, Function()? onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 28,
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      ),
    );
  }
}
