import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Auth/Presentation/Cubit/authCubit.dart';
import '../../../Domain/Entities/Profile.dart';
import '../../Cubits/profileCubit.dart';

class PersonInformation extends StatefulWidget {
  final ProfileUser? profileUser;
  final bool isAuthen;

  const PersonInformation(
      {super.key, this.profileUser, required this.isAuthen});

  @override
  State<PersonInformation> createState() => _PersonInformationState();
}

class _PersonInformationState extends State<PersonInformation> {
  bool readOnly = true;
  bool isObsecurity = true;

  final nameController = TextEditingController();

  void tapToSetImage() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tính năng chưa được cập nhật')));
  }

  void edit() {
    setState(() {
      readOnly = !readOnly;
    });
  }

  void resetPassword(String email) async {
    try {
      await context.read<Authcubit>().resetPass(email);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) => const AlertDialog(
                content: Text('Password reset link sent! Check your email'),
              ));
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (c) => AlertDialog(
                content: Text(e.message.toString()),
              ));
    }
  }

  void onUpdate() async {
    String name = nameController.text.trim();
    await context
        .read<Profilecubit>()
        .updateName(widget.profileUser!.uid, name);
    context.read<Profilecubit>().getProfile(widget.profileUser!.uid);
    setState(() {
      readOnly = true;
    });
  }

  @override
  void initState() {
    setState(() {
      nameController.text = widget.profileUser!.userName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('Thông tin tài khoản'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: size.height * 0.15,
                      width: size.height * 0.15,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 10,
                                spreadRadius: 1,
                                color: Colors.white)
                          ]),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/Unknown_person.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    GestureDetector(
                      onTap: tapToSetImage,
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height * 0.05,
                        width: size.height * 0.05,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt),
                      ),
                    )
                  ],
                ),
              ),

              //PersonInformation
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Text(
                    'Thông tin',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: edit,
                      icon: Icon(
                        Icons.edit,
                        size: 26,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Tên',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              itemTextFiled(nameController, false, 'Nhập tên'),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.profileUser!.email,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => widget.isAuthen
                    ? resetPassword(widget.profileUser!.email)
                    : null,
                child: const Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // button
              readOnly
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        itemButton('Huỷ', edit,
                            Theme.of(context).colorScheme.secondary),
                        itemButton(
                            'Cập nhật',
                            widget.isAuthen ? onUpdate : null,
                            Theme.of(context).colorScheme.secondaryContainer),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTextFiled(
      TextEditingController controller, bool isObsecurity, String hintText) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          border: readOnly
              ? InputBorder.none
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
      style: const TextStyle(fontSize: 20),
      obscureText: isObsecurity,
    );
  }

  Widget itemButton(String text, Function()? onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.elliptical(50, 50))),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
