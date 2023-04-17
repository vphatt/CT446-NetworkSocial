import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialnetwork/sources/auth_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/utils/tools.dart';
import 'package:socialnetwork/widgets/text_field_input.dart';

import '../responsive/mobile_screen.dart';
import '../responsive/responsive_screen.dart';
import '../responsive/web_sreen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
  }

  void selectImage() async {
    Uint8List pic = await pickImage(ImageSource.gallery);

    setState(() {
      _image = pic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Column(
              children: const [
                Text(
                  'TẠO MỘT TÀI KHOẢN MỚI',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            //Nhập username
            TextFieldInput(
                textEditingController: _usernameController,
                hintText: "Tên người dùng",
                textInputType: TextInputType.text),
            const SizedBox(
              height: 15,
            ),
            TextFieldInput(
                textEditingController: _nameController,
                hintText: "Tên của bạn",
                textInputType: TextInputType.text),
            const SizedBox(
              height: 15,
            ),
            // Nhập email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Địa chỉ email",
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 15,
            ),
            TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Mật khẩu",
                isPassword: true,
                textInputType: TextInputType.text),
            const SizedBox(
              height: 15,
            ),

            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://portal.staralliance.com/imagelibrary/aux-pictures/prototype-images/avatar-default.png/@@images/image.png'),
                      ),
                Positioned(
                  bottom: -8,
                  left: 60,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 30,
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(child: Text("Ảnh đại diện")),
            const SizedBox(
              height: 30,
            ),
            //NÚT ĐĂNG NHẬP
            InkWell(
              onTap: signUpUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Colors.orange),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text("ĐĂNG KÝ"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            // Flexible(
            //   flex: 1,
            //   child: Container(),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text("Bạn đã có tài khoản?"),
                ),
                GestureDetector(
                  onTap: switchToLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: const Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

//Phương thức đăng ký
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthFirebase().signUpUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveScreen(
            mobileScreenLayout: MobileScreen(),
            webScreenLayout: WebScreen(),
          ),
        ),
      );
    }
  }

  void switchToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
