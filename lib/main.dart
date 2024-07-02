import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Message_app> messages = [
    Message_app(
      userAvatarUrl:
          'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png',
      userName: 'Thanh Tuyền',
      messageContent: 'Hello, friend.',
      timestamp: '10:00 AM',
    ),
    Message_app(
      userAvatarUrl:
          'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png',
      userName: 'Yen Nhi',
      messageContent: 'Hi there!',
      timestamp: 'Yesterday',
    ),
    Message_app(
      userAvatarUrl:
          'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png',
      userName: 'Ty tyn',
      messageContent: 'How are you?',
      timestamp: '2 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Messenger',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MessengerScreen(userName: message.userName),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(message.userAvatarUrl),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          message.messageContent,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          message.timestamp,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
