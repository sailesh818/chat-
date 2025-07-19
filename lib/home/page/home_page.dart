import 'package:chat_app/chat/page/chat_screen.dart';
import 'package:chat_app/home/widget/app_drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      drawer: AppDrawerWidget(),
      appBar: AppBar(
        title: Row(
        children: [
          Text("Chat Users"),
          SizedBox(width: 20,),
        ],
      ),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.create))
      ],
      ), 
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(), 
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return const Center(child: Text("Error loading users"),);
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index){
              final user = users[index];
              if(user.id == currentUser?.uid){
                return const SizedBox();
              }
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen(
                      receiverId: user.id, 
                      receiverName: user['username'], 
                      receiverPhoto: user['photo'],
                    ))
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user['photo'] ?? '?'),
                  ),
                  title: Text(user['username'] ?? 'No name'),
                  subtitle: Text(user['email']),
                ),
              );
            }
          );
        }
      ),
    );
  }
}