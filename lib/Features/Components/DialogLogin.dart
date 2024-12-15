import 'package:flutter/material.dart';

class Dialoglogin extends StatelessWidget {
  Function()? onLoginTap;
  Dialoglogin({super.key, required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 150,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Thao tác cần đăng nhập',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 95,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: const Text(
                      'Thoát',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onLoginTap,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 95,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color:
                            Theme.of(context).colorScheme.secondaryContainer),
                    child: const Text(
                      'Đăng nhập',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
