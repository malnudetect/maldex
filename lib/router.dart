import 'package:flutter/material.dart';
import 'package:malnudetect/chat/screens/mobile_chat_screen.dart';
import 'package:malnudetect/group/screens/create_group_screen.dart';
import 'package:malnudetect/screens/chat_screen.dart';
import 'package:malnudetect/screens/login_screen.dart';
import 'package:malnudetect/screens/search_users_screen.dart';
import 'package:malnudetect/screens/signup_screen.dart';

Route<dynamic> genarateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());

    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );

    case ChatScreen.routeName:
      var arguments = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
          builder: (_) => ChatScreen(
                receiver: arguments,
              ));

    case MobileChatScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );

    case UserSearchScreen.routeName:
      return MaterialPageRoute(builder: (_) => UserSearchScreen());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("This route does not exist"),
          ),
        ),
      );
  }
}
