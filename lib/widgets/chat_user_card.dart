import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork/screen/chat_screen.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';

import '../models/message.dart';
import '../utils/mydate.dart';

class ChatUserCard extends StatefulWidget {
  final snap;
  //final message;
  const ChatUserCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: StreamBuilder(
          stream: FirestoreFirebase().getLastMessage(widget.snap['uid']),
          builder: ((context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            // final listUnRead =
            //     unRead.map((e) => Message.fromJson(e.data())).toList();
            if (list.isNotEmpty) _message = list[0];

            return StreamBuilder(
              stream: FirestoreFirebase().getNumberUnread(widget.snap['uid']),
              builder: ((context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshot2) {
                final data2 = snapshot2.data?.docs;

                final list2 =
                    data2?.map((e) => Message.fromJson(e.data())).toList() ??
                        [];

                int count = list2.length;
                return _message != null
                    ? ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(snap: widget.snap),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(widget.snap['avtUrl'])),
                        title: FirebaseAuth.instance.currentUser!.uid !=
                                widget.snap['uid']
                            ? Text('${widget.snap['name']}')
                            : const Text(
                                'Tôi',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 38, 115, 177),
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                        subtitle:
                            //********* Nếu là tin nhắn mình gửi đi*************/
                            _message!.fromId ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Row(
                                    children: [
                                      const Text('Bạn: '),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          _message!.msg,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )

                                //********* Nếu là tin nhắn mình nhận được nhưng chưa đọc *************/
                                : _message!.read.isEmpty
                                    ? Text(
                                        _message!.msg,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )

                                    //********* Nếu là tin nhắn mình nhận được và đã đọc rồi */
                                    : Text(
                                        _message!.msg,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                        trailing: list2.isNotEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Text(
                                      count.toString(),
                                      //count.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    MyDate.formatDate(
                                        context: context, time: _message!.sent),
                                    style:
                                        const TextStyle(color: secondaryColor),
                                  ),
                                ],
                              )
                            : Text(
                                MyDate.formatDate(
                                    context: context, time: _message!.sent),
                                style: const TextStyle(color: secondaryColor),
                              ),
                      )
                    : const SizedBox();
              }),
            );
          }),
        ),

        // ListTile(
        //   leading: CircleAvatar(
        //       radius: 30,
        //       backgroundImage: NetworkImage(widget.snap['avtUrl'])),
        //   title: FirebaseAuth.instance.currentUser!.uid != widget.snap['uid']
        //       ? Text('${widget.snap['name']}')
        //       : const Text(
        //           'Tôi',
        //           style: TextStyle(
        //               color: Color.fromARGB(255, 38, 115, 177),
        //               fontStyle: FontStyle.italic,
        //               fontWeight: FontWeight.bold),
        //         ),
        //   subtitle: Text(
        //     '${widget.message}',
        //     maxLines: 1,
        //   ),
        //   trailing: Text(
        //     '10:30',
        //     style: TextStyle(color: secondaryColor),
        //   ),
        // ),
      ),
    );
  }
}
