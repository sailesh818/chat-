import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverPhoto;
  
  const ChatScreen({
    super.key, 
    required this.receiverId, 
    required this.receiverName, 
    required this.receiverPhoto
    });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('chats').add({
      'senderId': currentUser!.uid,
      'receiverId': widget.receiverId,
      'text': messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Text(widget.receiverPhoto),
            ),
            const SizedBox(width: 8,),
            Text(widget.receiverName)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection('chats')
              .orderBy('timestamp', descending: true)
              .snapshots(), 
              builder: (context, snapshot){
                if(!snapshot.hasData) return const CircularProgressIndicator();

                final messages = snapshot.data!.docs.where((doc) {
                  final senderId = doc['senderId'];
                  final receiverId = doc['receiverId'];
                  return (senderId == currentUser!.uid && receiverId == widget.receiverId) ||
                         (senderId == widget.receiverId && receiverId == currentUser!.uid);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index){
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUser!.uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(msg['text']),
                      ),
                    );
                  }
                );
              }
              )
            ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}