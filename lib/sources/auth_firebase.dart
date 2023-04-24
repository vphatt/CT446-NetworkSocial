import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialnetwork/sources/storage_firebase.dart';
import 'package:socialnetwork/models/user.dart' as model;

class AuthFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetail() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //ĐĂNG KÝ TÀI KHOẢN
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String name,
    required Uint8List file,
  }) async {
    String res = "Đã xảy ra lỗi!";
    try {
      if (username.isNotEmpty ||
              email.isNotEmpty ||
              password.isNotEmpty ||
              name.isNotEmpty
          //  || file != null
          ) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //Phương thức thêm avt lênn firebase
        String avtUrl = await StorageFirebase()
            .uploadImageToStorage('avatarProfile', file, false);

        //Thêm tài khoản vào firebase

        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          avtUrl: avtUrl,
          name: name,
          follower: [],
          following: [],
        );

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "success";
      }
    }
    // on FirebaseException catch (err) {
    //   if (err.code == 'invalid-email') {
    //     res = "Địa chỉ email không hợp lệ!";
    //   } else if (err.code == 'weak-password') {
    //     res = "Mật khẩu phải có ít nhất 6 ký tự!";
    //   }
    // }
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  //ĐĂNG NHẬP
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Đã có lỗi xảy ra!";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Vui lòng nhập đầy đủ thông tin";
      }
    }
    //on FirebaseException catch (err) {
    //   if (err.code == 'invalid-email') {
    //     res = "Địa chỉ email không hợp lệ!";
    //   } else if (err.code == 'weak-password') {
    //     res = "Mật khẩu phải có ít nhất 6 ký tự!";
    //   }
    // }
    catch (err) {
      res = err.toString();
    }
    return res;
  }

  //ĐĂNG XUẤT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
