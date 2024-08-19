import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:malnudetect/constants/global_variables.dart';
import 'package:malnudetect/methods/storage_methods.dart';
import 'package:malnudetect/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
    required String phoneContact,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.UserModel user = model.UserModel(
          email: email,
          uid: credentials.user!.uid,
          phoneContact: phoneContact,
          photoUrl: photoUrl,
          username: name,
        );

        //storing user to database
        await _firestore
            .collection("users")
            .doc(credentials.user!.uid)
            .set(user.toJson());

        res = "success";
        //await sendEmailVerification()
        Fluttertoast.showToast(
          msg: "Account created Successfully",
          gravity: ToastGravity.CENTER,
          backgroundColor: GlobalVariables.primaryColor,
        );
      } else {
        res = "Please Enter all fields";
      }
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
        msg: "${e.message}",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red[800],
      );
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: "${e.message}",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red[800],
      );
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
