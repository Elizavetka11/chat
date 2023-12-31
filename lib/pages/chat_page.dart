import 'package:chat/components/chat_bubble.dart';
import 'package:chat/components/my_text_field.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserId;
  const ChatPage({
    super.key,
    required this.recieverUserEmail,
    required this.recieverUserId
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverUserId,
          _messageController.text);

      _messageController.clear();
    }

  }
  final messages = FirebaseFirestore.instance.collection('/chat_room/sqgsKCJMnMdE8Wqd14Ee63RjQ9k2_yIB7qOcT9iOSoC7EDpCmguCxkW33/messages');
//DELETE
    Future deleteMessage(String docId) async {
      return messages.doc(docId).delete();
  }
//UPDATE
    Future<void> updateMessage(String docId, String NewMessage ){
      return messages.doc(docId).update({
        'message': NewMessage,
        'timestamp': Timestamp.now(),
      });

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recieverUserEmail)),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),

          const SizedBox(height: 25,)
        ],
      )
    );
  }

  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.recieverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot){
        if (snapshot.hasError){
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');

        }
        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
    },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;


    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            ChatBubble(message: data['message']),
            IconButton(
              onPressed: () => updateMessage(document.id, 'Text'),
              icon: const Icon(Icons.update),
            ),
            IconButton(
              onPressed: () => deleteMessage(document.id),
              icon: const Icon(Icons.delete),
            )

          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [

          Expanded(
            child: MyTextFields(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),
          IconButton(onPressed: sendMessage, icon: Icon(
            Icons.arrow_upward,
            size: 40,
          ),
          )
        ],
      ),
    );
  }
}
