import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/screen/profile_screen.dart';
import 'package:socialnetwork/sources/firestore_firebase.dart';
import 'package:socialnetwork/utils/colors.dart';
import 'package:socialnetwork/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final snap;
  final lastSendMessage;
  const ChatScreen({Key? key, required this.snap, this.lastSendMessage})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //bool _isLoading = false;
  //List<Message> _list = [];

  //Giá trị true hoặc false để xác định hiện hoặc ẩn emoji
  bool _showEmoji = false;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;

  _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _scrollListener() {
    _firstAutoscrollExecuted = true;

    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _shouldAutoscroll = true;
    } else {
      _shouldAutoscroll = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    //_scrollDown();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        //_scrollDown();
      },
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 236, 236, 236),
          // appBar: AppBar(
          //   leading: CircleAvatar(
          //       radius: 30, backgroundImage: NetworkImage(widget.snap['avtUrl'])),
          // ),
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 223, 223, 223),
            ),
            toolbarHeight: 70,
            backgroundColor: const Color.fromARGB(255, 223, 223, 223),
            elevation: 3,
            title: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(uid: widget.snap['uid']),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget.snap['avtUrl']),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.snap['name'],
                    style: const TextStyle(color: primaryColor),
                  )
                ],
              ),
            ),
            iconTheme: const IconThemeData(color: primaryColor),
          ),

          body: Column(
            children: [
              // _isLoading
              //      const Expanded(
              //         child: Center(
              //           child: CircularProgressIndicator(
              //             color: themeColor,
              //           ),
              //         ),
              //       )
              //     :
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(
                          FirestoreFirebase().getDocumentId(widget.snap['uid']))
                      .collection('messages')
                      .orderBy('sent', descending: false)
                      .snapshots(),
                  builder: ((context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: themeColor,
                        ),
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? Center(
                            child: _helloButton(
                                widget.snap['uid'], widget.snap['name']),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data!.docs.length,
                            padding: const EdgeInsets.only(top: 10),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(
                                snap: widget.snap,
                                message: snapshot.data!.docs[index].data(),
                              );
                            },
                          );
                  }),
                ),
              ),
              _chatInput(),

              if (_showEmoji)
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: EmojiPicker(
                    onBackspacePressed: () {},
                    textEditingController: _messageController,
                    config: Config(
                      initCategory: Category.SMILEYS,
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isAndroid ? 1.30 : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      onTap: () {
                        _scrollToBottom;
                        if (_showEmoji) {
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                        }
                      },
                      controller: _messageController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: 'Viết tin nhắn...',
                          border: InputBorder.none),
                    )),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: themeColor,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                FirestoreFirebase().sendMessage(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.snap['uid'],
                    _messageController.text);
                _messageController.text = '';
              }
              _scrollToBottom();
            },
            shape: const CircleBorder(),
            height: 50,
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _helloButton(String uid, String name) {
    return InkWell(
      onTap: () {
        FirestoreFirebase().sendMessage(FirebaseAuth.instance.currentUser!.uid,
            widget.snap['uid'], 'Hello 👋');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Hello '),
                    Text(name),
                    const Text(' 👋')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
