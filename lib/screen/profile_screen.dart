import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:socialnetwork/screen/login_screen.dart';
import 'package:socialnetwork/sources/auth_firebase.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/tools.dart';

import '../utils/colors.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followersLength = 0;
  int followingLength = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      userData = snap.data()!; //thông tin user
      postLength = postSnap.docs.length; //tổng số lượng ảnh
      followersLength = userData['follower'].length; //tổng số người theo dõi
      followingLength =
          userData['following'].length; //tổng số người đang theo dõi
      isFollowing = userData['follower'].contains(FirebaseAuth
          .instance
          .currentUser!
          .uid); //kiểm tra người dùng hiện tại có đang theo dõi người dùng này hay không
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: themeColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: mobileBackgroundColor,
              ),
              toolbarHeight: 70,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return SimpleDialog(
                            title: const Text(
                              'Bạn có chắc muốn đăng xuất?',
                              style: TextStyle(color: primaryColor),
                            ),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SimpleDialogOption(
                                    child: const Text(
                                      'Đăng xuất',
                                      style: TextStyle(
                                          color: themeColor, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      await AuthFirebase().signOut();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Huỷ',
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                      );
                      // await AuthFirebase().signOut();
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) => const LoginScreen(),
                      //   ),
                      // );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: themeColor,
                    ))
              ],
              iconTheme: const IconThemeData(color: primaryColor),
              title: FirebaseAuth.instance.currentUser!.uid == widget.uid
                  ? const Text(
                      'Hồ Sơ Của Tôi',
                      style: TextStyle(color: primaryColor, fontSize: 25),
                    )
                  : const Text(
                      'Hồ Sơ',
                      style: TextStyle(color: primaryColor, fontSize: 25),
                    ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(userData['avtUrl']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          userData['name'],
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        userData['username'],
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Table(
                  children: [
                    TableRow(children: [
                      Text('$postLength',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                      Text('$followersLength',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('$followingLength',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))
                    ]),
                    const TableRow(children: [
                      Text(
                        'Ảnh',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text('Người theo dõi',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey)),
                      Text('Đang theo dõi',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey))
                    ])
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  child: Table(
                    border: TableBorder.all(color: secondaryColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? FollowButton(
                            text: 'Chỉnh sửa hồ sơ',
                            textColor: themeColor,
                            backgroundColor: mobileBackgroundColor,
                            borderColor: themeColor,
                            function: () {},
                          )
                        : isFollowing
                            ? FollowButton(
                                text: 'Bỏ theo dõi',
                                backgroundColor: mobileBackgroundColor,
                                borderColor: primaryColor,
                                textColor: primaryColor,
                                function: () async {
                                  await FirestoreFirebase().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid']);
                                  setState(() {
                                    isFollowing = false;
                                    followersLength--;
                                  });
                                },
                              )
                            : FollowButton(
                                text: 'Theo dõi',
                                backgroundColor: themeColor,
                                borderColor: themeColor,
                                textColor: mobileBackgroundColor,
                                function: () async {
                                  await FirestoreFirebase().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userData['uid'],
                                  );
                                  setState(() {
                                    isFollowing = true;
                                    followersLength++;
                                  });
                                },
                              ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        //.orderBy('datePublish', descending: true)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: themeColor,
                          ),
                        );
                      }
                      return GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  mainAxisExtent: 150,
                                  childAspectRatio: 2),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    },
                  ),
                )
              ],
            ));
  }
}
