import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/provider/user_provider.dart';
import 'package:socialnetwork/models/user.dart' as model;
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/utils/shared.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _selectedIndex = 0;
  late PageController pageController;

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
      // bottomNavigationBar: CupertinoTabBar(
      //   backgroundColor: mobileBackgroundColor,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home, color: _selectedIndex == 0),
      //       label: 'Trang Chủ',
      //       backgroundColor: primaryColor,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Tìm Kiếm',
      //       backgroundColor: primaryColor,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add),
      //       label: 'Bài Viết',
      //       backgroundColor: primaryColor,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'Thông Báo',
      //       backgroundColor: primaryColor,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //       backgroundColor: primaryColor,
      //     ),
      //   ],
      // ),
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: appBarColor,
        iconSize: 30,
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: navigationToSwitchPage,
        items: [
          FlashyTabBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Trang Chủ'),
              activeColor: themeColor,
              inactiveColor: primaryColor),
          FlashyTabBarItem(
              icon: const Icon(Icons.search),
              title: const Text('Tìm Kiếm'),
              activeColor: themeColor,
              inactiveColor: primaryColor),
          FlashyTabBarItem(
              icon: const Icon(Icons.add_circle),
              title: const Text('Bài Viết'),
              activeColor: themeColor,
              inactiveColor: primaryColor),
          FlashyTabBarItem(
              icon: const Icon(Icons.notifications),
              title: const Text('Thông Báo'),
              activeColor: themeColor,
              inactiveColor: primaryColor),
          FlashyTabBarItem(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.avtUrl),
            ), //Icon(Icons.person),
            title: const Text('Hồ Sơ'),
            activeColor: themeColor,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  // void navigationToSwitchPage(int page) {
  //   pageController.jumpToPage(page);
  //   _selectedIndex = page;
  // }

  void navigationToSwitchPage(int page) => setState(() {
        pageController.jumpToPage(page);
        _selectedIndex = page;
      });

  void onPageChanged(int page) {
    setState(() {
      _selectedIndex = page;
    });
  }
}
