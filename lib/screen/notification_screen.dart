import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: mobileBackgroundColor,
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Thông Báo',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: primaryColor),
      ),
    );
  }
}
