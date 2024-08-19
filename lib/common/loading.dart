import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      // color: Colors.grey[400],
      child: Center(
        child: SpinKitWave(
          color: Color.fromARGB(255, 96, 100, 203),
        ),
      ),
    );
  }
}
