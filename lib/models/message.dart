import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';

class Message {
  late final String msgId;
  late final String fromId;
  late final String toId;
  late final String msg;
  late final String read;
  late final String sent;
  late final Type type;

  Message({
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

  Message.fromJson(Map<String, dynamic> snapshot) {
    //var snapshot = snap.data() as Map<String, dynamic>;

    msgId = snapshot['msgId'].toString();
    fromId = snapshot['fromId'].toString();
    toId = snapshot['toId'].toString();
    msg = snapshot['msg'].toString();
    read = snapshot['read'].toString();
    sent = snapshot['sent'].toString();
    type = snapshot['type'] == Type.image.name ? Type.image : Type.text;
  }
}

enum Type { text, image }
