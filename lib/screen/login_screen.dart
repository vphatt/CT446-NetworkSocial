import 'package:flutter/material.dart';
import 'package:socialnetwork/screen/signup_screen.dart';
import 'package:socialnetwork/sources/auth_firebase.dart';

import 'package:socialnetwork/utils/tools.dart';
import 'package:socialnetwork/widgets/text_field_input.dart';

import '../responsive/mobile_screen.dart';
import '../responsive/responsive_screen.dart';
import '../responsive/web_sreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                  "Welcome!",
                  style: TextStyle(fontSize: 70),
                ),
                Text(
                  'Đăng nhập để tiếp tục',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            // Nhập email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Địa chỉ email",
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 30,
            ),
            TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Mật khẩu",
                isPassword: true,
                textInputType: TextInputType.text),
            const SizedBox(
              height: 30,
            ),

            //NÚT ĐĂNG NHẬP
            InkWell(
              onTap: loginUser,
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
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "ĐĂNG NHẬP",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            Flexible(
              flex: 1,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text("Bạn chưa có tài khoản?"),
                ),
                GestureDetector(
                  onTap: switchToSignUp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: const Text(
                      "ĐĂNG KÝ",
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

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthFirebase().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveScreen(
            mobileScreenLayout: MobileScreen(),
            webScreenLayout: WebScreen(),
          ),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void switchToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }
}
