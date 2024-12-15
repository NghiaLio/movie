import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class loadingIndicator extends StatelessWidget {
  const loadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child:Container(
          alignment: Alignment.center,
          height: size.height *0.3,
          width: size.width*0.25,
          child: const LoadingIndicator(
            indicatorType: Indicator.pacman,
            colors: [
              Colors.deepOrange,
              Colors.yellow
            ],
          ),
        ) ,
      ),
    );
  }
}
