import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/widgets/post_box.dart';

import '../utils/colors.dart';

class PostDetailScreen extends StatefulWidget {
  final snap;
  const PostDetailScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: themeColor,
        ),
        title: Text('Bài Viết của ${widget.snap.data()['name']}',
            style: const TextStyle(color: mobileBackgroundColor)),
        toolbarHeight: 70,
        backgroundColor: themeColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: mobileBackgroundColor),
      ),
      body: PostBox(snap: widget.snap),
    );
  }
}
