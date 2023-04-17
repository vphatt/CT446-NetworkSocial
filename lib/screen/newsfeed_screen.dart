import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/widgets/post_box.dart';

class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: mobileBackgroundColor,
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Social Network',
          style: TextStyle(fontFamily: 'Nice', color: themeColor, fontSize: 40),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.messenger,
                color: primaryColor,
              )),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublish', descending: true)
            .snapshots(),
        builder: (context,
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
            itemBuilder: ((context, index) => PostBox(
                  snap: snapshot.data!.docs[index].data(),
                )),
          );
        },
      ),
    );
  }
}
