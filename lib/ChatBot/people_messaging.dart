import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:malnudetect/Chat/screens/mobile_chat_screen.dart';
import 'package:malnudetect/common/loading.dart';
import 'package:malnudetect/models/email_contact.dart';
import 'package:malnudetect/models/user.dart';

class PeopleMessaging extends StatefulWidget {
  const PeopleMessaging({super.key});

  @override
  State<PeopleMessaging> createState() => _PeopleMessagingState();
}

class _PeopleMessagingState extends State<PeopleMessaging> {
  Stream<List<EmailContact>> getmessagers() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messagers")
        .snapshots()
        .asyncMap((event) async {
      List<EmailContact> pipowhomessage = [];
      for (var element in event.docs) {
        var messagermap = EmailContact.fromMap(element.data());

        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(messagermap.contactId)
            .get();

        var user = UserModel.fromMap(userData.data()!);

        pipowhomessage.add(
          EmailContact(
              name: user.username,
              profilePic: user.photoUrl,
              contactId: user.uid,
              timeSent: messagermap.timeSent,
              lastMessage: messagermap.lastMessage),
        );
      }
      return pipowhomessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: getmessagers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Loading();
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  children: [
                    Text('fetching chats ....... '),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var snapdata = snapshot.data![index];

                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, MobileChatScreen.routeName,
                      arguments: {
                        'name': snapdata.name,
                        'uid': snapdata.contactId,
                        'isGroupChat': false,
                        'profilePic': "imageUrl",
                      }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(221, 187, 169, 169),
                            borderRadius: BorderRadius.circular(25)),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapdata.name,
                                style: const TextStyle(fontSize: 34),
                              ),
                            ])),
                  ),
                );
              },
            );
          }),
    );
  }
}
