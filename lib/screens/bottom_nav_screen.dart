import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:malnudetect/Chat/chat_screen.dart';
import 'package:malnudetect/screens/detection_screen.dart';

class BottomNavScreen extends StatefulWidget {
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
    const ChatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: const Color.fromARGB(255, 96, 100, 203),
              showLabel: false,
              notchColor: const Color.fromARGB(255, 96, 100, 203),
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
                  itemLabel: 'Page 1',
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
                  itemLabel: 'Page 2',
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
