import 'package:flutter/material.dart';
import 'package:socialnetwork/screen/chat_home_screen.dart';
import 'package:socialnetwork/screen/my_profile_screen.dart';
import 'package:socialnetwork/screen/newsfeed_screen.dart';
import 'package:socialnetwork/screen/search_screen.dart';

const mobileSreenSize = 600;

List<Widget> homeScreenItems = [
  const NewsFeed(),
  const SearchScreen(),
  //const Text(''),
  const ChatHomeScreen(),
  const MyProfileScreen(),
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  // ),
];
