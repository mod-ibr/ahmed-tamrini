import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tamrini/utils/app_constants.dart';
import 'package:tamrini/utils/constants.dart';

import '../../data/user_data.dart';
import '../../provider/user_provider.dart';
import '../../utils/widgets/button_widget.dart';
import '../../utils/widgets/global Widgets.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  final String chatID;

  const ChatScreen({
    super.key,
    required this.chatID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> users = [];
  bool isTrainer = false;
  String userName = '';
  String token = '';
  List<Map<String, dynamic>> messages = [];

  final messageTextController = TextEditingController();
  String messageText = '';

  @override
  void initState() {
    super.initState();
    getUsersData();
  }

  getUsersData() async {
    users = await downloadUsersData();
    setState(() => _loading = false);
  }

  void sendMessage() async {
    if (messageText.isNotEmpty) {
      Timestamp currTime = Timestamp.now();

      FirebaseFirestore.instance.collection('chats').doc(widget.chatID).set({
        'messages': FieldValue.arrayUnion(
          [
            {
              'time': currTime,
              'message': messageText,
              'senderID':
                  Provider.of<UserProvider>(context, listen: false).user.uid,
            },
          ],
        ),
      }, SetOptions(merge: true));

      messageTextController.clear();
      await sendNotification(
          senderUserName:
              Provider.of<UserProvider>(context, listen: false).user.name,
          token: token,
          chatId: widget.chatID);
    } else {
      Fluttertoast.showToast(
          msg: context.locale.languageCode == 'ar'
              ? 'اكتب رسالتك أولا!'
              : 'Write your message first!');
    }
  }

  Future<void> sendNotification(
      {required String senderUserName,
      required String token,
      required String chatId}) async {
    try {
      log("Receiver Token : $token");
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$kServerToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': (context.locale.languageCode == 'ar')
                  ? 'رسالة جديدة'
                  : "New Message",
              'body': (context.locale.languageCode == 'ar')
                  ? 'رسالة جديدة من  $senderUserName'
                  : "New Message from $senderUserName",
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'token': token,
              'chatId': chatId,
              "type": 'chat'
            },
            'to': token,
          },
        ),
      );
      await updateReceiverNotifications(
          token: token, senderUserName: senderUserName);
    } catch (e) {
      log("Error while send notification : $e");
    }
  }

  Future<void> updateReceiverNotifications(
      {required String token, required String senderUserName}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('token', isEqualTo: token)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Loop through the documents and update the 'failed' field
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final String userId = doc.id;

        // Update the 'failed' field to your desired value
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'notification': true,
          'notifications': FieldValue.arrayUnion([
            {
              'title': 'رسالة جديدة',
              'body': 'رسالة جديدة من  $senderUserName',
              'createsAt': Timestamp.now(),
            }
          ])
        });

        print('Updated "failed" field for user with ID: $userId');
      }
    } else {
      // No admin users found
      print('No admin users found.');
    }
  }

  Stream<DocumentSnapshot> getChatStream() {
    log('chat id : ${widget.chatID}');
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatID)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    isTrainer = Provider.of<UserProvider>(context).user.role == 'captain';
    return _loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : StreamBuilder<DocumentSnapshot>(
            stream: getChatStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> chatData = {};
              String docID = '';

              if (snapshot.hasError) {
                return Center(
                  child: ButtonWidget(
                    text: tr('server_error'),
                    // text: 'مشكلة في السيرفر ،العودة للصفحة السابقة',
                    onClicked: () => Navigator.pop(context),
                  ),
                );
              }
              if (snapshot.data == null ||
                  !snapshot.data!.exists ||
                  snapshot.data!.data() == null ||
                  (snapshot.data!.data()! as Map).isEmpty) {
                return Center(
                  child: ButtonWidget(
                    text: tr('chat_error'),
                    // text: 'مشكلة في الدردشة ،العودة للصفحة السابقة',
                    onClicked: () => Navigator.pop(context),
                  ),
                );
              } else {
                chatData = snapshot.data!.data() as Map<String, dynamic>;
                messages = chatData['messages'] == null
                    ? []
                    : (chatData['messages'] as List)
                        .map((e) => (e as Map).map(
                            (key, value) => MapEntry(key as String, value)))
                        .toList();
                docID = chatData[isTrainer ? 'userID' : 'trainerID'];
                int index = users.indexWhere((user) => user['docID'] == docID);
                if (index != -1) {
                  userName = users[index]['name'];
                  token = users[index]['token'];
                  log("********************************** token : $token");
                } else {
                  return Center(
                    child: ButtonWidget(
                      text: tr('user_error'),
                      // text: 'الشخص غير متوفر الان ،العودة للصفحة السابقة',
                      onClicked: () => Navigator.pop(context),
                    ),
                  );
                }
              }
              return Scaffold(
                appBar: globalAppBar(userName),
                body: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MessagesStream(messages: messages),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.sp,
                              horizontal: 8.sp,
                            ),
                            decoration: const BoxDecoration(
                              border:
                                  Border(top: BorderSide(color: Colors.grey)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    controller: messageTextController,
                                    onChanged: (value) {
                                      // Update messageText when the user types.
                                      setState(() => messageText = value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: tr('write_message'),
                                      // hintText: 'اكتب رسالتك...',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 10.0,
                                      ),
                                      border: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: kSecondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: () => sendMessage(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class MessagesStream extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesStream({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    List<MessageBubble> messageBubbles = [];

    for (Map<String, dynamic> message in messages) {
      final String messageText = message['message'] ?? ' ';
      final Timestamp messageTime = message['time'];
      final String messageSenderID = message['senderID'];

      final messageBubble = MessageBubble(
        time: messageTime,
        text: messageText,
        isMe: messageSenderID == Provider.of<UserProvider>(context).user.uid,
      );
      messageBubbles.add(messageBubble);
    }
    messageBubbles.sort((a, b) => b.time.compareTo(a.time));
    return Expanded(
      child: ListView(
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: messageBubbles,
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final Timestamp time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe
                ? const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(30.0),
                    bottomStart: Radius.circular(30.0),
                    topStart: Radius.circular(30.0))
                : const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(30.0),
                    bottomStart: Radius.circular(30.0),
                    topEnd: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Theme.of(context).primaryColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            DateFormat.jm().format(time.toDate()),
            style: TextStyle(
              fontSize: 12.sp,
              // color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
