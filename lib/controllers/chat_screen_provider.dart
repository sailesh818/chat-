import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreenProvider extends ChangeNotifier{
  final TextEditingController messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> sendMessage(String receiverId) async {
    if (messageController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('chats').add({
      'senderId': currentUser!.uid,
      'receiverId': receiverId,
      'text': messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
    notifyListeners();

  }
  Stream<QuerySnapshot> ChatStream(){
    return FirebaseFirestore.instance
              .collection('chats')
              .orderBy('timestamp', descending: true)
              .snapshots();
  }
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
  
}