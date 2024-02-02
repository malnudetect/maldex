import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malnudetect/common/loading.dart';
import 'package:malnudetect/models/user.dart';
import 'package:malnudetect/screens/chat_screen.dart';
import 'package:malnudetect/screens/search_users_screen.dart';

class ContactsListScreen extends ConsumerWidget {
  const ContactsListScreen({super.key});

  Stream fetchUsers() {
    var usersnap = FirebaseFirestore.instance.collection("users").snapshots();

    return usersnap.asyncMap((event) {
      for (var element in event.docs) {
        var userdata = element.data();
        var usermodeldata = UserModel.fromMap(userdata);

        ListTile(
          title: Text(usermodeldata.username),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 10,
                textStyle: GoogleFonts.bubblegumSans(fontSize: 20)),
            onPressed: () =>
                Navigator.pushNamed(context, UserSearchScreen.routeName),
            child: const Text("Search users to Chat with"),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                }
                var gotdata = snapshot.data!.docs.map((e) {
                  return e.data();
                }).toList();

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          ChatScreen.routeName,
                          arguments: gotdata[index],
                        ),
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.black45),
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      minRadius: 30,
                                      backgroundImage: NetworkImage(
                                          "${gotdata[index]["photoUrl"]}"),
                                    ),
                                    Text('${gotdata[index]['username']}'),
                                  ])),
                        ),
                      ),
                    );
                  },
                  itemCount: gotdata.length,
                );
              }),
        ),
      ],
    ));
  }
}
