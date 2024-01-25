// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyAnimatedImageWidget();
    //  Ink(
    //   height: 200,
    //   width: 500,
    //   decoration: const BoxDecoration(
    //       image: DecorationImage(
    //     fit: BoxFit.contain,
    //     image: AssetImage("assets/logo/goldenq.png"),
    //   )),
    // );
  }
}

class MyAnimatedImageWidget extends StatefulWidget {
  const MyAnimatedImageWidget({super.key});

  @override
  _MyAnimatedImageWidgetState createState() => _MyAnimatedImageWidgetState();
}

class _MyAnimatedImageWidgetState extends State<MyAnimatedImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> animation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Set the duration of the animation
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 720).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Animation has completed, reset it
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // Animation has reversed, play it forward again
          _controller.forward();
        }
      });

    // Start the animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          child: Image.asset('assets/logo/goldenq.png'),
          scale: 0.5,
          // origin: Offset(10, 10),
        );
        // return Transform.rotate(
        //   angle: _animation.value * 3.1415927 / 180,
        //   child: Image.asset(
        //       'assets/logo/goldenq.png'), // Replace 'your_image.png' with your image asset path
        // );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
