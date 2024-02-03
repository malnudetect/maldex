// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malnudetect/constants/global_variables.dart';
import 'package:malnudetect/widgets/chat_list.dart';
import 'package:malnudetect/widgets/bottom_chart_field.dart.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = "/chat-screen";
  final Map<String, dynamic> receiver;
  const ChatScreen({
    super.key,
    required this.receiver,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.primaryColor,
        centerTitle: true,
        title: Text("${widget.receiver["username"]}"),
        leading: Container(
          margin: const EdgeInsets.only(left: 20),
          child: CircleAvatar(
            minRadius: 30,
            backgroundImage: NetworkImage("${widget.receiver["photoUrl"]}"),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ChatList(
                recieverUserId: widget.receiver["uid"],
                isGroupChat: false,
              ),
            ),
            BottomChatField(
              recieverUserId: widget.receiver["uid"],
              isGroupChat: false,
            )
          ],
        ),
      ),
    );
  }
}
