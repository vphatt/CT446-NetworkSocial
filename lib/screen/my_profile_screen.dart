import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:socialnetwork/screen/edit_profile_screen.dart';
import 'package:socialnetwork/screen/login_screen.dart';
import 'package:socialnetwork/sources/auth_firebase.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/tools.dart';
import 'package:socialnetwork/widgets/list_follow_screen.dart';

import '../utils/colors.dart';
import '../widgets/follow_button.dart';

class MyProfileScreen extends StatefulWidget {
  //final String uid;
  const MyProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  var userData = {};
  int id = 0;
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
      var snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
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
                title: const Text(
                  'Hồ Sơ Của Tôi',
                  style: TextStyle(color: primaryColor, fontSize: 25),
                )),
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
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ListFollowScreen(
                                uid: uid,
                                isFollower: true,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '$followersLength',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ListFollowScreen(
                                uid: uid,
                                isFollower: false,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '$followingLength',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
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
                    FollowButton(
                      text: 'Chỉnh sửa hồ sơ',
                      textColor: themeColor,
                      backgroundColor: mobileBackgroundColor,
                      borderColor: themeColor,
                      function: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(uid: userData['uid'])));
                      },
                    )
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: uid)
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

  // void refreshData() {
  //   id++;
  // }

  // onGoBack(dynamic value) {
  //   refreshData();
  //   setState(() {});
  // }

  // navigateEditProfileScreen(uid) {
  //   Route route =
  //       MaterialPageRoute(builder: (context) => EditProfileScreen(uid: uid));
  //   Navigator.push(context, route).then(onGoBack);
  // }
}
