import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socialnetwork/utils/colors.dart';

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
                  const Icon(
                    Icons.done_all_outlined,
                    color: Colors.blue,
                    size: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      '${widget.message['read']}${DateFormat('HH:mm').format(
                        widget.message['sent'].toDate(),
                      )}',
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
                  DateFormat('HH:mm').format(
                    widget.message['sent'].toDate(),
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
