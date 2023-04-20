import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork/utils/colors.dart';

class ChatUserCard extends StatefulWidget {
  final snap;
  const ChatUserCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.snap['avtUrl'])),
              title:
                  FirebaseAuth.instance.currentUser!.uid != widget.snap['uid']
                      ? Text('${widget.snap['name']}')
                      : const Text(
                          'Tôi',
                          style: TextStyle(
                              color: Color.fromARGB(255, 38, 115, 177),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
              subtitle: Text(
                'Tin nhắn cuối',
                maxLines: 1,
              ),
              trailing: Text(
                '10:30',
                style: TextStyle(color: secondaryColor),
              ),
            )),
      ),
    );
  }
}
