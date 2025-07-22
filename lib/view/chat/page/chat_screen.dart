import 'package:chat_app/controllers/chat_screen_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatScreenProvider(),
      child: Consumer<ChatScreenProvider>(
        builder: (context, provider, child) {
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
                    stream:  provider.ChatStream(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData) return const CircularProgressIndicator();
          
                      final messages = snapshot.data!.docs.where((doc) {
                        final senderId = doc['senderId'];
                        final receiverId = doc['receiverId'];
                        return (senderId == provider.currentUser!.uid && receiverId == widget.receiverId) ||
                               (senderId == widget.receiverId && receiverId == provider.currentUser!.uid);
                      }).toList();
          
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index){
                          final msg = messages[index];
                          final isMe = msg['senderId'] == provider.currentUser!.uid;
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
                          controller: provider.messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => provider.sendMessage(widget.receiverId),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}