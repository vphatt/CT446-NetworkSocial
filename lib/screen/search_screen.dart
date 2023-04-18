import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/screen/profile_screen.dart';
import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool showUser = false;

  // @override
  // void dispose() {
  //   super.dispose();
  //   searchController.dispose();
  // }

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
              onFieldSubmitted: (String _) {
                setState(() {
                  //print(searchController);
                  showUser = true;
                });
                //print(searchController.text);
                // print(searchController);
              },
            )),
        body: showUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username'.toLowerCase(),
                        isGreaterThanOrEqualTo:
                            searchController.text.toLowerCase())
                    .get(),
                builder: (context,
                    //AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: themeColor,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid']))),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['avtUrl']),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ['username']),
                          ));
                    },
                  );
                },
              )
            : const Center(
                child: Text('Tìm kiếm người dùng'),
              ));
  }
}
