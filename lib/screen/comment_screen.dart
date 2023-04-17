import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/models/user.dart' as model;

import '../provider/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  const CommentScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: themeColor),
        title: const Text(
          'Bình luận',
          style: TextStyle(color: themeColor),
        ),
      ),
      body: CommentBox(
          userImage: NetworkImage(user.avtUrl),
          labelText: 'Bình luận với tên ${user.name}',
          errorText: 'Bình luận trống!', //'Bình luận trống!',
          withBorder: true,
          commentController: _commentController,
          sendButtonMethod: () async {
            // print(commentController.text);
            if (formKey.currentState!.validate()) {
              FirestoreFirebase().postComment(widget.postId,
                  _commentController.text, user.uid, user.name, user.avtUrl);
              // setState(() {
              //   var value = {
              //     'name': user.name,
              //     'pic': user.avtUrl,
              //     'message': _commentController.text,
              //     'date': '2021-01-01 12:00:00'
              //   };
              //   //comments_on_post.insert(0, value);
              // });
              _commentController.clear();
              FocusScope.of(context).unfocus();
            }
          },
          formKey: formKey,
          backgroundColor: secondaryColor,
          textColor: Colors.white,
          sendWidget:
              const Icon(Icons.send_sharp, size: 30, color: Colors.white),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('datePublish', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => CommentCard(
                  snap: snapshot.data!.docs[index],
                ),
              );
            },
          ) //commentChild(comments_on_post),
          ),
    );
  }
}
