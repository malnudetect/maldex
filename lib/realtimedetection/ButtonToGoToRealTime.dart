// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:malnudetect/realtimedetection/main.dart';

class ButtonToGoToRealTime extends StatefulWidget {
  const ButtonToGoToRealTime({super.key});

  @override
  State<ButtonToGoToRealTime> createState() => _ButtonToGoToRealTimeState();
}

class _ButtonToGoToRealTimeState extends State<ButtonToGoToRealTime> {
  static const double radius = 34;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 7,
            blurRadius: 1,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          elevation: MaterialStateProperty.all(23),
        ),
        onPressed: () =>
            Navigator.pushNamed(context, RealTimeDetectionScreen.routeName),
        child: const Text(
          'Go to Real-Time Detection',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
