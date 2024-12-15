import 'package:flutter/material.dart';

class Errorscreen extends StatelessWidget {
  const Errorscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 80,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          const Center(
            child: Text(
              'Có lỗi xảy ra vui lòng thử lại sau',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
