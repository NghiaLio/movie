import 'package:flutter/material.dart';

class Checkconnect extends StatefulWidget {
  const Checkconnect({super.key});

  @override
  State<Checkconnect> createState() => _CheckconnectState();
}

class _CheckconnectState extends State<Checkconnect> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 50,color: Colors.red,),
          SizedBox(height: 20,),
          Center(
            child: Text(
              'Kiểm tra kết nối mạng',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
    );
  }
}
