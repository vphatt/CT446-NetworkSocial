import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/provider/user_provider.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/utils/tools.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: themeColor,
                ),
                onPressed: clearImage,
              ),
              centerTitle: true,
              title: const Text(
                'Bài viết...',
                style: TextStyle(color: primaryColor),
              ),
              actions: [
                TextButton(
                    onPressed: () => postImage(
                        user.uid, user.username, user.name, user.avtUrl),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: themeColor),
                          )
                        : const Text(
                            'Đăng',
                            style: TextStyle(
                                color: themeColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))
              ],
            ),
            body: Column(
              children: [
                //_isLoading ? const LinearProgressIndicator() : Container(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avtUrl),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: width * 0.8,
                      child: TextField(
                          controller: _editingController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            // filled: true,
                            // fillColor: Colors.amber,
                            hintText: 'Bạn đang nghĩ gì?',
                            border: InputBorder.none,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.4,
                  width: width * 0.8,
                  child: AspectRatio(
                    aspectRatio: width * 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(image: MemoryImage(_file!))),
                    ),
                  ),
                )
              ],
            ),
          );
  }

//Hàm chọn hình ảnh

  Uint8List? _file;

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return SimpleDialog(
            title: const Text(
              'Tạo bài viết',
              style: TextStyle(color: themeColor),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.only(
                    right: 30, left: 30, top: 20, bottom: 20),
                child: RichText(
                    text: const TextSpan(children: [
                  WidgetSpan(child: Icon(Icons.camera_alt)),
                  TextSpan(
                      text: '\tChụp ảnh',
                      style: TextStyle(color: primaryColor, fontSize: 17))
                ])),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.only(
                    right: 30, left: 30, top: 20, bottom: 20),
                child: RichText(
                    text: const TextSpan(children: [
                  WidgetSpan(child: Icon(Icons.photo_library)),
                  TextSpan(
                      text: '\tChọn ảnh',
                      style: TextStyle(color: primaryColor, fontSize: 17))
                ])),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Huỷ',
                      style: TextStyle(
                        color: secondaryColor,
                      )))
            ],
          );
        }));
  }

  //Kiểm soát soạn thảo văn bản
  final TextEditingController _editingController = TextEditingController();

  //Hàm đăng tải bài viết
  void postImage(
      String uid, String username, String description, String avt) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreFirebase().uploadPost(
          _editingController.text, _file!, uid, username, description, avt);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Bài viết đã được đăng!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  //Tạo vòng tròn loading khi ấn ĐĂNG
  bool _isLoading = false;

  //Xoá hình ảnh đã chọn
  void clearImage() {
    setState(() {
      _file = null;
    });
  }
}
