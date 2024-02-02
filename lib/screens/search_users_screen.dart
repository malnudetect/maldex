// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:malnudetect/screens/chat_screen.dart';

class UserSearchScreen extends StatefulWidget {
  static const routeName = "/search-screen";
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  void searchUsers(String query) {
    // Perform a query to Firestore based on the search query
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: '${query}z')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Search'),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(34)),
                hintText: 'Search for users...',
              ),
              onChanged: (value) {
                // Implement search logic here
                searchUsers(value);
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    var user =
                        searchResults[index].data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        ChatScreen.routeName,
                        arguments: user,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(221, 187, 169, 169),
                                borderRadius: BorderRadius.circular(25)),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    minRadius: 30,
                                    backgroundImage:
                                        NetworkImage("${user["photoUrl"]}"),
                                  ),
                                  Text('${user['username']}'),
                                ])),
                      ),
                    );
                  }))
        ]));

    // return ListTile(

    //   title: Text(user['username']),
    //   subtitle: Text(user['email']),
    // );
  }
}
