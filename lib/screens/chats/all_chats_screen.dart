import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/chats/chat_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../data/user_data.dart';
import '../../utils/widgets/button_widget.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('chats')),
      // appBar: globalAppBar('المحادثات'),
      body: const ChatList(),
    );
  }
}

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool _loading = true;
  List<Map<String, dynamic>> users = [];
  bool isTrainer = false;

  Stream<QuerySnapshot> getChatsStream() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where(
          isTrainer ? 'trainerID' : 'userID',
          isEqualTo: Provider.of<UserProvider>(context).user.uid,
        )
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    getUsersData();
  }

  getUsersData() async {
    users = await downloadUsersData();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    isTrainer = Provider.of<UserProvider>(context).user.role == 'captain';
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: getChatsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: ButtonWidget(
                    text: tr('server_error'),
                    // text: 'مشكلة في السيرفر ،العودة للصفحة السابقة',
                    onClicked: () => Navigator.pop(context),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    tr('no_chats'),
                    // 'لا توجد محادثات حالية',
                    style: TextStyle(
                        fontSize: 25, color: Theme.of(context).primaryColor),
                  ),
                );
              }
              List<QueryDocumentSnapshot> allChats = snapshot.data?.docs ?? [];
              Map<String, dynamic> chatData = {};
              String docID = '';
              List<Map<String, dynamic>> validChats = [];
              for (QueryDocumentSnapshot chat in allChats) {
                if (!chat.exists || chat.data() == null) continue;
                chatData = chat.data() as Map<String, dynamic>;
                docID = chatData[isTrainer ? 'userID' : 'trainerID'];
                int index = users.indexWhere((user) => user['docID'] == docID);
                if (index != -1) {
                  validChats.add({
                    'id': chat.id,
                    'name': users[index]['name'],
                    'username': users[index]['username'],
                    'imageUrl': users[index]['avatar'],
                  });
                }
              }
              return ListView.builder(
                itemCount: validChats.length,
                itemBuilder: (context, index) {
                  return ChatTile(
                    id: validChats[index]['id'],
                    name: validChats[index]['name'],
                    userName: validChats[index]['username'],
                    imageUrl: validChats[index]['imageUrl'],
                  );
                },
              );
            },
          );
  }
}

class ChatTile extends StatelessWidget {
  final String id;
  final String name;
  final String userName;
  final String imageUrl;

  const ChatTile({
    super.key,
    required this.id,
    required this.name,
    required this.userName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: buildImage(context, imageUrl),
        title: Text(name),
        subtitle: Text(userName),
        onTap: () {
          To(ChatScreen(chatID: id));
        },
      ),
    );
  }

  Widget buildImage(context, imagePath) {
    final size = MediaQuery.sizeOf(context);
    return ClipOval(
      child: Container(
        color: const Color(0xffdbdbdb),
        child: CachedNetworkImage(
          imageUrl: imagePath,
          fit: BoxFit.cover,
          height: size.width * 0.15,
          width: size.width * 0.15,
          placeholder: (context, url) {
            if (url.isEmpty) {
              return Icon(
                Icons.person_rounded,
                size: size.width * 0.15,
                color: Colors.white,
              );
            }
            return Container(
              alignment: Alignment.center,
              width: size.width * 0.15,
              height: size.width * 0.15,
              child: const CircularProgressIndicator(),
            );
          },
          errorWidget: (context, url, error) => Icon(
            Icons.person_rounded,
            size: size.width * 0.15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
