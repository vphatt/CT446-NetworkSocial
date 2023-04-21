import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/screen/comment_screen.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';

import '../provider/user_provider.dart';

import 'package:socialnetwork/models/user.dart' as model;

import '../screen/profile_screen.dart';

class PostBox extends StatefulWidget {
  final snap;
  const PostBox({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostBox> createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  bool isLiked = false;
  var likeDB = FirebaseFirestore.instance.collection('posts');
  String uid = '';
  String postId = '';
  int likeCount = 0;
  List list = [];
  int commentLength = 0;
  bool myPost = false;
  bool isLoading = false;

  var userData = {};
  String name = '';
  String username = '';

  @override
  void initState() {
    super.initState();

    uid = FirebaseAuth.instance.currentUser!.uid;
    postId = widget.snap['postId'];

    //userData = getInfo.data()!;

    list = widget.snap['like'];

    if (list.contains(uid)) {
      isLiked = true;
    }
    getCommentLength();

    if (widget.snap['uid'] == uid) {
      myPost = true;
    }
  }

  void getCommentLength() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      var getInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();
      userData = getInfo.data()!;
      name = userData['name'];
      username = userData['username'];
      commentLength = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      //getCommentLength();
      isLoading = false;
    });
  }

// Future<bool> checkMyPost(uid) {
//   uid
// return
//   }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    //model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
        //color: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 3))),
        child: Column(
          children: [
            //Header của phần bài đăng

            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                  .copyWith(right: 0),
              child: Row(children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(uid: widget.snap['uid']),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget.snap['avt']),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: widget.snap['uid']),
                            ),
                          ),
                          child: Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: primaryColor)),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(uid: widget.snap['uid']),
                            ),
                          ),
                          child: Text(username,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                  color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                ),
                myPost
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                      child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    children: ['Xoá bài viết']
                                        .map((e) => InkWell(
                                            onTap: () async {
                                              FirestoreFirebase().deletePost(
                                                  widget.snap['postId']);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 20),
                                              child: Text(e),
                                            )))
                                        .toList(),
                                  )));
                        },
                        icon: const Icon(Icons.more_vert))
                    : const SizedBox(),
              ]),
            ),

            //Phần hình ảnh của bài đăng

            //Phần mô tả Caption
            widget.snap['caption'].isNotEmpty
                ? Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      widget.snap['caption'],
                    ),
                  )
                : const SizedBox(
                    height: 3,
                  ),

            SizedBox(
              //height: height * 0.3,
              width: double.infinity,
              child:
                  Image.network(widget.snap['postUrl'], fit: BoxFit.fitWidth),
            ),
            const SizedBox(
              height: 10,
            ),
            //Like và Comment
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    LikeButton(
                      isLiked: isLiked,
                      likeBuilder: (bool isLiked) {
                        return widget.snap['like'].contains(uid)
                            ? const Icon(
                                Icons.favorite,
                                color: themeColor,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: primaryColor,
                              );
                      },
                      onTap: (isLiked) async {
                        if (isLiked == true) {
                          await likeDB.doc(postId).update({
                            'like': FieldValue.arrayRemove([uid]),
                          });
                        } else {
                          await likeDB.doc(postId).update({
                            'like': FieldValue.arrayUnion([uid]),
                          });
                        }
                        return !isLiked;
                      },
                    ),
                    Text(
                      '${widget.snap['like'].length}',
                      style: const TextStyle(color: secondaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                    postId: widget.snap['postId']),
                              ),
                            ),
                        icon: const Icon(
                          Icons.comment,
                          color: primaryColor,
                        )),
                    Text('$commentLength',
                        style: const TextStyle(color: secondaryColor)),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: primaryColor,
                        )),
                  ],
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                            "Đã đăng ${DateFormat('dd/MM/yyyy - HH:mm').format(
                              widget.snap['datePublish'].toDate(),
                            )}",
                            style: const TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
              ],
            ),

            //Nút xem tất cả bình luận

            // const SizedBox(
            //   height: 15,
            // ),
            // Container(
            //   height: 10,
            //   color: const Color.fromARGB(255, 224, 224, 224),
            // )
          ],
        ));
  }
}
