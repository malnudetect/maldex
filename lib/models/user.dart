// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

enum AccountTypeEnum {
  Premium,
  Normal,
}

class UserModel {
  static const admin = "admin";
  static const client = "client";

  final String username;
  final String uid;
  final String email;
  final String photoUrl;
  final String role;
  final AccountTypeEnum accountType;

  UserModel(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.username,
      required this.role,
      required this.accountType});

  static fromSnap(DocumentSnapshot snap) async {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        email: snapshot["email"],
        uid: snapshot["uid"],
        photoUrl: snapshot["photoUrl"],
        username: snapshot["username"],
        role: snapshot["role"] ?? client,
        accountType: convertAccountStatusStringToAccountStatusEnum(
            snapshot["accountType"] ?? AccountTypeEnum.Normal.name));
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "role": role,
        "accountType": accountType.toString().split(".").last
      };

  static fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map["email"] as String,
        uid: map["uid"] as String,
        photoUrl: map["photoUrl"] as String,
        username: map["username"] as String,
        role: map["role"] as String? ?? client,
        accountType: convertAccountStatusStringToAccountStatusEnum(
            map["account"] ?? AccountTypeEnum.Normal.name));
  }

  static AccountTypeEnum convertAccountStatusStringToAccountStatusEnum(
      String accountStatus) {
    switch (accountStatus) {
      case "Premium":
        return AccountTypeEnum.Premium;
      case "Normal":
        return AccountTypeEnum.Normal;
      default:
        throw ArgumentError("Unknown account status: $accountStatus");
    }
  }
}
