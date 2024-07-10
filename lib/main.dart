import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart' as chatview;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBsEnsitAk_PJhHJja7645hwK1nNODzUSQ",
        appId: "1:731312504025:ios:a36060defc4816589c52c8",
        messagingSenderId: "731312504025",
        projectId: "chat-app-b0a8e",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class User {
  final String name;
  final int age;
  final String? avatar;

  User({
    required this.name,
    required this.age,
    this.avatar,
    });

  //fromMap
  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        avatar = map['avatar'],
        age = map['age'];
        @override
  String toString() {
    return 'User{name: $name, age: $age}';
  }
}
class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class ChatUser {
  final String id;
  final String name;
  final String profilePic;

  ChatUser({required this.id, required this.name, required this.profilePic});
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  // List<ChatUser> friends = [
  //   ChatUser(id: '1', name: 'Thanh Tuyền', profilePic: 'https://random.imagecdn.app/200/300'),
  //   ChatUser(id: '2', name: 'Yen Nhi', profilePic: 'https://picsum.photos/200/300'),
  //   ChatUser(id: '3', name: 'Ty tyn', profilePic: 'https://picsum.photos/seed/picsum/200/300'),
  // ];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // listen realtime
      FirebaseFirestore.instance
          .collection("users")
          .snapshots()
          .listen((event) {
        final users = event.docs.map((e) => User.fromMap(e.data())).toList();
        print(users);
        setState(() {
          this.users = users;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Messenger',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.add, size: 30),
                      backgroundColor: Colors.blue[100],
                    ),
                  );
                } else {
                  final friend = users[index - 1];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(friend.avatar??''),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final friend = users[index + 1 ];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return MessengerScreen(friend: friend);
                    }));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.5),
                    padding: const EdgeInsets.all(5),
                    color: Colors.white,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(friend.avatar??''),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  friend.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 24),
                                ),
                                Text(
                                  'Hello, friend.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w700),
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.blue),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black),
            activeIcon: Icon(Icons.chat, color: Colors.blue[400]),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: Colors.black),
            activeIcon: Icon(Icons.group, color: Colors.blue[400]),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black),
            activeIcon: Icon(Icons.settings, color: Colors.blue[400]),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class MessengerScreen extends StatefulWidget {
  final User friend;

  MessengerScreen({required this.friend});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  var messageList = [
    chatview.Message(message: 'Hello', createdAt: DateTime.now(), sentBy: '1'),
    chatview.Message(message: 'Hi', createdAt: DateTime.now(), sentBy: '2'),
  ];
  
  late final chatController = chatview.ChatController(
    initialMessageList: messageList,
    scrollController: ScrollController(),
    currentUser: chatview.ChatUser(id: '1', name: 'Ty Tyn', profilePhoto: ''),
    otherUsers: [chatview.ChatUser(id: '2', name: widget.friend.name, profilePhoto: widget.friend.avatar)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: chatview.ChatView(
        chatController: chatController,
        onSendTap: (message, replyMessage, messageType) {
          chatController.addMessage(chatview.Message(
              message: message, createdAt: DateTime.now(), sentBy: '1'));
        },
        sendMessageConfig: chatview.SendMessageConfiguration(
          textFieldBackgroundColor: Colors.black,
          allowRecordingVoice: false,
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
        ),
        chatViewState: chatview.ChatViewState.hasMessages,
      ),
    );
  }
}
