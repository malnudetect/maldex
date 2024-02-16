import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malnudetect/ChatBot/people_messaging.dart';

class ChatBotScreen extends ConsumerStatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends ConsumerState<ChatBotScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Expanded(
        child: PeopleMessaging(),
      ),
    );
  }
}
