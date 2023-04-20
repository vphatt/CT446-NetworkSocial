import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/widgets/chat_user_card.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: themeColor,
        ),
        toolbarHeight: 70,
        backgroundColor: themeColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Trò Chuyện',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_comment),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 222, 222, 222),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: themeColor,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: ((context, index) =>
                    ChatUserCard(snap: snapshot.data!.docs[index].data())
                // {
                //   return
                //   Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //     child: Card(
                //       elevation: 2,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15)),
                //       child: InkWell(
                //           onTap: () {},
                //           child:
                //           ListTile(
                //             leading: CircleAvatar(
                //                 radius: 30,
                //                 backgroundImage: NetworkImage(
                //                     snapshot.data!.docs[index].data()['avtUrl'])),
                //             title: Text(
                //                 '${snapshot.data!.docs[index].data()['name']}'),
                //             subtitle: Text(
                //               'Tin nhắn cuối',
                //               maxLines: 1,
                //             ),
                //             trailing: Text(
                //               '10:30',
                //               style: TextStyle(color: secondaryColor),
                //             ),
                //           ),
                //           ),
                //     ),
                //   );
                // }
                ),
          );
        }),
      ),
    );
  }
}