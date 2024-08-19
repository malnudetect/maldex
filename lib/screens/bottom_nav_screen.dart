import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:malnudetect/Chat/screens/chat_section_screen.dart';
import 'package:malnudetect/constants/global_variables.dart';
import 'package:malnudetect/realtimedetection/main.dart';
import 'package:malnudetect/screens/detection_screen.dart';

class BottomNavScreen extends StatefulWidget {
  static const routeName = '/bottom-nav-screen';
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const DetectionScreen(),
    const RealTimeDetectionScreen(),
    const ChatSectionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        // physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              kIconSize: 23,
              kBottomRadius: 23,
              notchBottomBarController: _controller,
              color: GlobalVariables.primaryColor,
              showLabel: false,
              notchColor: GlobalVariables.primaryColor,
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                  ),
                  itemLabel: 'Home Page',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.video_camera_front_outlined,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.video_camera_front_outlined,
                    color: Colors.white,
                  ),
                  itemLabel: 'Real-Time-Detection',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  itemLabel: 'Chat Page',
                ),

                ///svg example
              ],
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}
