// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Trial extends ConsumerStatefulWidget {
  const Trial({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrialState();
}

class _TrialState extends ConsumerState<Trial> {
  someFunc() {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final repoControllerProvider = Provider((ref) {
  return RepositoryController(repo: ref.watch(repositoryProvider), ref: ref);
});

class RepositoryController {
  final Repository repo;
  final ProviderRef ref;
  RepositoryController({
    required this.repo,
    required this.ref,
  });

  void getCriminals() {
    repo.getCriminals();
  }
}

final repositoryProvider = Provider((ref) {
  return Repository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class Repository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  Repository({
    required this.firestore,
    required this.auth,
  });

  getCriminals() async {
    firestore
        .collection("parents")
        .doc(auth.currentUser!.uid)
        .collection("children")
        .snapshots()
        .asyncMap((event) async {
      List<Criminal> criminals = [];
      for (var document in event.docs) {
        var childData = ChildModel.fromMap(document.data());

        var criminaldata =
            await firestore.collection("criminals").doc(childData.uid).get();

        var criminal = Criminal.fromMap(criminaldata.data()!);

        criminals.add(Criminal(
          name: criminal.name,
          crime: criminal.crime,
          arrestperiod: criminal.arrestperiod,
          country: criminal.country,
        ));
      }
      return criminals;
    });
  }
}

class Criminal {
  final String name;
  final String crime;
  final String arrestperiod;
  final String country;
  Criminal({
    required this.name,
    required this.crime,
    required this.arrestperiod,
    required this.country,
  });

  static fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Criminal(
      name: snap["name"],
      crime: snap["crime"],
      arrestperiod: snap["arrestperiod"],
      country: snap["country"],
    );
  }

  factory Criminal.fromMap(Map<String, dynamic> map) {
    return Criminal(
        name: map["name"],
        crime: map["crime"],
        arrestperiod: map["arrestperiod"],
        country: map["country"]);
  }
}

class ChildModel {
  final String uid;
  final String name;
  final String age;
  final String sex;
  final String country;
  ChildModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.sex,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "age": age,
      "sex": sex,
      "country": country,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      uid: map["uid"],
      name: map["name"],
      age: map["age"],
      sex: map["sex"],
      country: map["country"],
    );
  }
}
