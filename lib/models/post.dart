import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String name;
  final String avt;
  final String postId;
  final String caption;
  final datePublish;
  final String postUrl;
  final like;

  const Post(
      {required this.uid,
      required this.username,
      required this.name,
      required this.avt,
      required this.postId,
      required this.caption,
      required this.datePublish,
      required this.postUrl,
      required this.like});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'name': name,
        'avt': avt,
        'postId': postId,
        'caption': caption,
        'datePublish': datePublish,
        'postUrl': postUrl,
        'like': like
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        uid: snapshot['uid'],
        username: snapshot['username'],
        name: snapshot['name'],
        avt: snapshot['avt'],
        postId: snapshot['postId'],
        caption: snapshot['caption'],
        datePublish: snapshot['datePublish'],
        postUrl: snapshot['postUrl'],
        like: snapshot['like']);
  }
}
