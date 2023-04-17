import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String uid;
  final String username;
  final String name;
  final String email;
  final String avtUrl;

  final List follower;
  final List following;

  const User(
      {required this.uid,
      required this.username,
      required this.name,
      required this.email,
      required this.avtUrl,
      required this.follower,
      required this.following});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'name': name,
        'email': email,
        'avtUrl': avtUrl,
        'follower': follower,
        'following': following
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        uid: snapshot['uid'],
        username: snapshot['username'],
        name: snapshot['name'],
        email: snapshot['email'],
        avtUrl: snapshot['avtUrl'],
        follower: snapshot['follower'],
        following: snapshot['following']);
  }
}
