import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malnudetect/ChatBot/chatbot_screen.dart';
import 'package:malnudetect/constants/global_variables.dart';
import 'package:malnudetect/screens/contacts_list_screen.dart';

class ChatSectionScreen extends ConsumerStatefulWidget {
  const ChatSectionScreen({super.key});

  @override
  ConsumerState<ChatSectionScreen> createState() => _ChatSectionScreenState();
}

class _ChatSectionScreenState extends ConsumerState<ChatSectionScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 2, vsync: this);
  }

  late TabController tabBarController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.primaryColor,
          title: Text(
            "Chat Section",
            style: GoogleFonts.bubblegumSans(
              fontSize: 34,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: GlobalVariables.tabColor,
            indicatorWeight: 3,
            labelColor: GlobalVariables.tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: "CHATS",
              ),
              Tab(
                text: "CHATBOT",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [
            ContactsListScreen(),
            ChatBotScreen(),
          ],
        ),
      ),
    );
  }
}
