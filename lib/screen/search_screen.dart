import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.search, color: primaryColor),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: mobileBackgroundColor,
          ),
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Tìm kiếm người dùng...',
              //labelStyle: TextStyle(color: primaryColor),
            ),
            onFieldSubmitted: (value) {
              setState(() {
                print(searchController);
                showUser = true;
              });
              // print(searchController);
            },
          )),
      body: showUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: themeColor,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!.docs[index]['avtUrl']),
                      ),
                      title: Text(snapshot.data!.docs[index]['username']),
                    );
                  },
                );
              },
            )
          : Text('post'),
    );
  }
}
