import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malnudetect/common/loading.dart';
import 'package:malnudetect/screens/home_screen.dart';
import 'package:path/path.dart';

class Verification extends StatefulWidget {
  static String? userRole;
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  void initState() {
    super.initState();
    userModeCheck();
  }

  userModeCheck() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

    final data = snapshot.data();

    setState(() {
      Verification.userRole = data!["role"] as String;
    });
  }

  Future<Widget> adminOrClientCheck() async {
    var currentUserData = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var roledata = currentUserData.data()!["role"];

    if (roledata == "admin") {
      return const MyHomePage();
    } else {
      return const MyHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: adminOrClientCheck(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data ?? Container();
        } else {
          return const Center(
            child: Loading(),
          );
        }
      },
    );

    // switch (Verification.userRole) {
    //   case "admin":
    //     return const CounterScreen();
    //   case "client":
    //     return const CustomerFirstScreen();
    //   default:
    //     return const SizedBox(
    //       height: 300,
    //       child: Text("Unknown user "),
    //     );
    // }
    // if (Verification.userRole == "admin") {
    //   return const CounterScreen();
    // } else {
    //   return const CustomerFirstScreen();
    // }
  }
}
