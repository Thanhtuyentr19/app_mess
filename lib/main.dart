import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart' as chatview;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  List<ChatUser> friends = [
    ChatUser(id: '1', name: 'Thanh Tuyền', profilePic: 'https://random.imagecdn.app/200/300'),
    ChatUser(id: '2', name: 'Yen Nhi', profilePic: 'https://picsum.photos/200/300'),
    ChatUser(id: '3', name: 'Ty tyn', profilePic: 'https://picsum.photos/seed/picsum/200/300'),
  ];

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
              itemCount: friends.length + 1,
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
                  final friend = friends[index - 1];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(friend.profilePic),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
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
                            backgroundImage: NetworkImage(friend.profilePic),
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
  final ChatUser friend;

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
    otherUsers: [chatview.ChatUser(id: widget.friend.id, name: widget.friend.name, profilePhoto: widget.friend.profilePic)],
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
