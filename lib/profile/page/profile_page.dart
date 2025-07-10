import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? email;
  String? photo;
  bool isloading = true;
  bool isEditing = false;

  final usernameController = TextEditingController();

  @override
  void initState(){
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try{
      final user = FirebaseAuth.instance.currentUser;
      if(user  != null){
        final uid = user.uid;
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if(doc.exists){
          setState(() {
            usernameController.text = doc['username'];
            email = doc['email'];
            photo = doc['photo'];
            isloading = false;

          });
        } else {
          throw Exception("User document not found");
        }
      } else {
        throw Exception("User not logged in");
      }

    }catch(e){
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Loading profile: ${e.toString()}")));

    }
  }

  Future<void> updateUserData() async {
    try {
      final newUsername = usernameController.text.trim();
      if(newUsername.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username cannot be empty")));
        return;
      }
      final newphoto = newUsername[0].toUpperCase();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'username': newUsername,
        'photo': newphoto,
      });
      setState(() {
        photo = newphoto;
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated Successfully")));

    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update: ${e.toString()}")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page"),),
      body: isloading
      ? const Center(child: CircularProgressIndicator(),)
      : Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                child: Text(
                  photo ?? "?",
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 20),
              isEditing
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: usernameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                      labelText: "Edit Username",
                      border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: updateUserData,
                 ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    usernameController.text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                email ?? "No Email",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
    );
  }
}