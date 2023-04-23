import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/utils/mydate.dart';

import '../models/message.dart';

class MessageCard extends StatefulWidget {
  final message;
  final snap;
  const MessageCard({Key? key, required this.message, this.snap})
      : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  String readLength = '';

  @override
  void initState() {
    super.initState();
    getLength();
  }

  getLength() async {
    try {
      var read = widget.message['read'].toString();
      readLength = read;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      //print(readLength);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.uid == widget.message['fromId']
        ? _messageSend()
        : _messageReceive();
  }

  //Tin nhắn gửi đi
  Widget _messageSend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 200,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(top: 20, right: 10),
                decoration: const BoxDecoration(
                  color: messageSendColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  widget.message['msg'],
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.message['read'].isNotEmpty
                      ? const Icon(
                          Icons.done_all_outlined,
                          color: Colors.blue,
                          size: 20,
                        )
                      : const SizedBox(),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      MyDate.formatDate(
                        context: context,
                        time: widget.message['sent'],
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

//Tin nhắn nhận
  Widget _messageReceive() {
    //Cập nhật trạng trái đã đọc của tin nhắn cuối cùng
    if (widget.message['read'].isEmpty) {
      FirestoreFirebase()
          .updateReadStatus(widget.snap['uid'], widget.message['msgId']);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(top: 20, left: 10),
                decoration: const BoxDecoration(
                  color: messageReceiveColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(5)),
                ),
                child: Text(
                  widget.message['msg'],
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  MyDate.formatDate(
                    context: context,
                    time: widget.message['sent'],
                  ),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 200,
        ),
      ],
    );
  }
}
