import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      child: const Center(
        child: SpinKitWave(
          color: Color.fromARGB(255, 191, 0, 255),
        ),
      ),
    );
  }
}
