import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:socialnetwork/models/user.dart';
import 'package:socialnetwork/sources/auth_firebase.dart';

class UserProvider with ChangeNotifier {
  final AuthFirebase _authFirebase = AuthFirebase();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authFirebase.getUserDetail();
    _user = user;
    notifyListeners();
  }
}
