import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialnetwork/screen/my_profile_screen.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';

import '../utils/colors.dart';
import '../utils/tools.dart';
import '../widgets/text_field_input.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  const EditProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var userData = {};

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Uint8List? _image;
  bool _loadPage = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _nameController.dispose();
  }

  bool _isLoading = false;

  void selectImage() async {
    Uint8List pic = await pickImage(ImageSource.gallery);

    setState(() {
      _image = pic;
    });
  }

  getData() async {
    setState(() {
      _loadPage = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = snap.data()!;
      _usernameController.text = userData['username'];
      _nameController.text = userData['name'];

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _loadPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadPage
        ? const Center(
            child: CircularProgressIndicator(
              color: themeColor,
            ),
          )
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: mobileBackgroundColor,
                  ),
                  title: const Text(
                    'Chỉnh Sửa Hồ Sơ',
                    style: TextStyle(color: primaryColor),
                  ),
                  toolbarHeight: 70,
                  backgroundColor: Colors.white,
                  elevation: 2,
                  iconTheme: const IconThemeData(color: primaryColor),
                  centerTitle: true,
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      Stack(children: [
                        Center(
                          child: _image != null
                              ? CircleAvatar(
                                  radius: 100,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : CircleAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      NetworkImage(userData['avtUrl']),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: MediaQuery.of(context).size.width / 2,
                          child: MaterialButton(
                            onPressed: selectImage,
                            height: 60,
                            elevation: 5,
                            color: themeColor,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                'Tên người dùng (username)',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  TextFieldInput(
                                      textEditingController:
                                          _usernameController,
                                      hintText: userData['username'],
                                      textInputType: TextInputType.text),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text(
                                'Tên của bạn',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFieldInput(
                                  textEditingController: _nameController,
                                  hintText: userData['name'],
                                  textInputType: TextInputType.text),
                              const SizedBox(
                                height: 15,
                              ),
                            ]),
                      ),
                      TextButton(
                          onPressed: () => updateUser(
                              userData['uid'],
                              _usernameController.text,
                              _nameController.text,
                              _image!),
                          // async {
                          //   await
                          //   FirestoreFirebase().updateInfo(
                          //       userData['uid'],
                          //       _usernameController.text,
                          //       _nameController.text,
                          //       _image!);
                          // },
                          child: Container(
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: mobileBackgroundColor),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.edit,
                                        color: mobileBackgroundColor,
                                      ),
                                      Text(
                                        '  Cập Nhật',
                                        style: TextStyle(
                                            color: mobileBackgroundColor,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                          ))
                    ],
                  ),
                )),
          );
  }

  void updateUser(
      String uid, String username, String name, Uint8List avt) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreFirebase()
          .updateInfo(userData['uid'], username, name, avt);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar('Thông tin đã được cập nhật', context);
        returnProfile();
      } else {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void returnProfile() {
    setState(() {
      Navigator.of(context).pop(true);
    });
  }
}
