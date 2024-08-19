// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:malnudetect/screens/login_screen.dart';

class SignOutButton extends StatelessWidget {
  BuildContext context;
  SignOutButton({
    Key? key,
    required this.context,
  }) : super(key: key);
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 255, 17, 0))),
      onPressed: signOut,
      child: const Text("Sign Out"),
    );
  }
}
