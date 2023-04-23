import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialnetwork/models/message.dart';
import 'package:socialnetwork/sources/storage_firebase.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  //CHỈNH SỬA THÔNG TIN
  Future<String> updateInfo(
      String uid, String username, String name, dynamic avt) async {
    String res = "Đã có lỗi xảy ra!";
    try {
      // DocumentSnapshot snap =
      //     await _firestore.collection('users').doc(uid).get();
      // Reference avt =
      //     FirebaseStorage.instance.ref().child('avatarProfile').child(uid);
      if (avt == Uint8List) {
        String avtUrl = await StorageFirebase()
            .uploadImageToStorage('avatarProfile', avt, false);

        await _firestore
            .collection('users')
            .doc(uid)
            .update({'username': username, 'name': name});
      } else {
        await _firestore
            .collection('users')
            .doc(uid)
            .update({'username': username, 'name': name});
      }

      //await _firestore.collection('posts').where('uid', isEqualTo: uid)
      // Post post =
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //LẤY TOÀN BỘ TIN NHẮN
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(String uid) {
    return _firestore
        .collection('chats')
        .doc(FirestoreFirebase().getDocumentId(uid))
        .collection('messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //TẠO ID DOCUMENT CỦA COLLECTION "CHAT"
  String getDocumentId(String id) =>
      FirebaseAuth.instance.currentUser!.uid.hashCode <= id.hashCode
          ? '${FirebaseAuth.instance.currentUser!.uid}_$id'
          : '${id}_${FirebaseAuth.instance.currentUser!.uid}';

  //GỬI TIN NHẮN
  Future<String> sendMessage(String uid, String recId, String msg) async {
    String res = "Đã có lỗi xảy ra!";
    try {
      String msgId = const Uuid().v1();
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      Message message = Message(
          msgId: msgId,
          fromId: uid,
          toId: recId,
          msg: msg,
          read: '',
          sent: time,
          type: Type.text);

      _firestore
          .collection('chats')
          .doc(getDocumentId(recId))
          .collection('messages')
          .doc(msgId)
          .set(message.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //CẬP NHẬT TRẠNG THÁI ĐÃ XEM CỦA TIN NHẮN GỬI ĐI
  Future<void> updateReadStatus(String id, String msgId) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    _firestore
        .collection('chats')
        .doc(getDocumentId(id))
        .collection('messages')
        .doc(msgId)
        .update({
      'read': time,
    });
  }
}
