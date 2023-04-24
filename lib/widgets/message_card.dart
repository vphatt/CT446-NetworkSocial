import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/utils/mydate.dart';

class MessageCard extends StatefulWidget {
  final dynamic message;
  final dynamic snap;
  //final Message lastSendMessage;
  const MessageCard({
    Key? key,
    required this.message,
    this.snap,
  }) : super(key: key);

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
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: ((context) {
            return SimpleDialog(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                          'Đã gửi ${MyDate.formatDateWithDDMMYYYY(context: context, time: widget.message['sent'])} lúc ${MyDate.formatDate(context: context, time: widget.message['sent'])}'),
                      widget.message['read'].isNotEmpty
                          ? Text(
                              'Đã xem ${MyDate.formatDateWithDDMMYYYY(context: context, time: widget.message['read'])} lúc ${MyDate.formatDate(context: context, time: widget.message['read'])}')
                          : const Text('Chưa xem'),
                    ],
                  ),
                )
              ],
            );
          }),
        );
      },
      child: Row(
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
                // if (widget.message['msgId'] == widget.lastSendMessage.msgId)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: widget.message['read'].isNotEmpty
                      ? Text(
                          'Đã xem ${MyDate.formatDate(
                            context: context,
                            time: widget.message['read'],
                          )}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      : Text(
                          'Đã gửi ${MyDate.formatDate(
                            context: context,
                            time: widget.message['sent'],
                          )}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//Tin nhắn nhận
  Widget _messageReceive() {
    //Cập nhật trạng trái đã đọc của tin nhắn cuối cùng
    if (widget.message['read'].isEmpty) {
      FirestoreFirebase()
          .updateReadStatus(widget.snap['uid'], widget.message['msgId']);
    }

    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: ((context) {
            return SimpleDialog(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        'Đã nhận ${MyDate.formatDateWithDDMMYYYY(context: context, time: widget.message['sent'])} lúc ${MyDate.formatDate(context: context, time: widget.message['sent'])}'),
                  ),
                )
              ],
            );
          }),
        );
      },
      child: Row(
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
      ),
    );
  }
}
