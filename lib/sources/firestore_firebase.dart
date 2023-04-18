import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialnetwork/sources/storage_firebase.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //ĐĂNG ẢNH
  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String name, String avt) async {
    String res = "Đã có lỗi xảy ra!";
    try {
      String pictureUrl =
          await StorageFirebase().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        username: username,
        name: name,
        avt: avt,
        postId: postId,
        caption: caption,
        datePublish: DateTime.now(),
        postUrl: pictureUrl,
        like: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //XOÁ ẢNH
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //ĐĂNG COMMENT
  Future<void> postComment(
      String postId, String text, String uid, String name, String avt) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'avt': avt,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublish': DateTime.now(),
        });
      } else {
        print('Bình luận trống!');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //THEO DÕI NGƯỜI DÙNG
  Future<void> followUser(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
