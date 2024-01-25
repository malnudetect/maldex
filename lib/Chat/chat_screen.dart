import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return GiffyDialog.image(
          Image.network(
            "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
            height: 200,
            fit: BoxFit.cover,
          ),
          title: const Text(
            'Image Animation',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'This is a image animation dialog box. This library helps you easily create fancy giffy dialog.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'CANCEL'),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 100, 203),
          title: Text(
            "Chat Section",
            style: GoogleFonts.bubblegumSans(
              fontSize: 34,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: const DefaultTabController(
          length: 2,
          child: Column(),
        ));
  }
}
