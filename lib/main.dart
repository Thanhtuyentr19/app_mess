import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Message',
          style: TextStyle(color: Colors.black,
            fontWeight: FontWeight.bold,),
          ),
      ),

      body: Container(
        color: Colors.blue,
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('U'),
              ),
              title: Text('User $index'),
              subtitle: Text('Message $index'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessengerScreen(userName: 'User $index'),
                  ),
                );
              },
            );
          },
        ),
      )
    );
  }
}

class Message_app {
  final String userAvatarUrl;
  final String userName;
  final String messageContent;
  final String timestamp;

  Message_app({
    required this.userAvatarUrl,
    required this.userName,
    required this.messageContent,
    required this.timestamp,
  });
}

class MessengerScreen extends StatefulWidget {
  final String userName;

  MessengerScreen({required this.userName});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  int currentIndex = 0;
  var messageList = [
    Message(message: 'Hello', createdAt: DateTime.now(), sentBy: '1'),
    Message(message: 'Hi', createdAt: DateTime.now(), sentBy: '2'),
  ];

  late final chatController = ChatController(
    initialMessageList: messageList,
    scrollController: ScrollController(),
    currentUser: ChatUser(id: '1', name: 'Minh'),
    otherUsers: [ChatUser(id: '2', name: 'Nhi')],
  );

  @override
  Widget build(BuildContext context) {
    print('rebuild UI');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: ChatView(
        chatController: chatController,
        onSendTap: (message, replyMessage, messageType) {
          chatController.addMessage(Message(
              message: message, createdAt: DateTime.now(), sentBy: '1'));
        },
        sendMessageConfig: SendMessageConfiguration(
          textFieldBackgroundColor: Colors.black,
          allowRecordingVoice: false,
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
        ),
        chatViewState:
            ChatViewState.hasMessages, 
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
            icon: Icon(Icons.contacts, color: Colors.black),
            activeIcon: Icon(Icons.contacts, color: Colors.blue[400]),
            label: 'People',
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

  Widget buildConversationTile(
      String name, String message, String time, String imageUrl) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: SizedBox(
        width: 50,
        child: Text(
          time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () {},
    );
  }
}
