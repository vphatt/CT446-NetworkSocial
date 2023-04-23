import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';

class Message {
  final String msgId;
  final String fromId;
  final String toId;
  final String msg;
  final String read;
  final String sent;
  final Type type;

  const Message({
    required this.msgId,
    required this.fromId,
    required this.toId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'msgId': msgId,
        'fromId': fromId,
        'toId': toId,
        'msg': msg,
        'read': read,
        'sent': sent,
        'type': type.name,
      };

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
      msgId: snapshot['msgId'],
      fromId: snapshot['fromId'],
      toId: snapshot['toId'],
      msg: snapshot['msg'],
      read: snapshot['read'],
      sent: snapshot['sent'],
      type: snapshot['type'] == Type.image.name ? Type.image : Type.text,
    );
  }
}

enum Type { text, image }
