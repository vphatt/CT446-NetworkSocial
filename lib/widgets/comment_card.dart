import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screen/profile_screen.dart';
import '../utils/colors.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = '';

    //var userData = FirebaseFirestore.instance.collection('users').doc(snap['uid']).get();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
        child: ListTile(
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(uid: snap.data()['uid']),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(snap.data()['avt'])),
              ),
            ),
            title: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: snap.data()['name'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColor),
              ),
              TextSpan(
                text: '\t\t${DateFormat('dd/MM/yyyy - HH:mm').format(
                  snap['datePublish'].toDate(),
                )}',
                style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                    fontSize: 13),
              )
            ])),
            subtitle: Text(
              snap.data()['text'],
              style: const TextStyle(
                color: primaryColor,
              ),
              textAlign: TextAlign.justify,
            ),
            trailing: RichText(
                text: TextSpan(children: [
              WidgetSpan(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                ),
              ),
              WidgetSpan(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              )
            ]))
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.more_vert),
            // ),
            ),
      ),
    );
  }
}
