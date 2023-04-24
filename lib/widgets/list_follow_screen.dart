import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/widgets/follow_user_card.dart';

import '../utils/colors.dart';

class ListFollowScreen extends StatefulWidget {
  final String uid;
  final bool isFollower;
  const ListFollowScreen(
      {Key? key, required this.uid, required this.isFollower})
      : super(key: key);

  @override
  State<ListFollowScreen> createState() => _ListFollowScreenState();
}

class _ListFollowScreenState extends State<ListFollowScreen> {
  bool isLoading = false;
  var userData = {};
  List follower = [];
  List following = [];

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

      userData = snap.data()!;
      follower = userData['follower'];
      following = userData['following'];

      //var getFollower = await FirebaseFirestore.instance.collection('users').
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
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
            // backgroundColor: Color.fromARGB(255, 233, 233, 233),
            appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: themeColor,
                ),
                toolbarHeight: 70,
                backgroundColor: themeColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: mobileBackgroundColor),
                title: widget.isFollower
                    ? Text(
                        'Người theo dõi ${userData['name']}',
                        style: const TextStyle(color: mobileBackgroundColor),
                      )
                    : Text(
                        'Người ${userData['name']} đang theo dõi',
                        style: const TextStyle(color: mobileBackgroundColor),
                      )),
            body: widget.isFollower
                ? ListView.builder(
                    itemCount: follower.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: ((context, index) =>
                        FollowUserCard(uid: follower[index])),
                  )
                : ListView.builder(
                    itemCount: following.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: ((context, index) =>
                        FollowUserCard(uid: following[index])),
                  ));
  }
}
