import 'package:chat_app/view/home/page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPageProvider extends ChangeNotifier{
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  Future<void> login(BuildContext context) async {
  if (emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter both email and password")),
    );
    return;
  }
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailcontroller.text, 
      password: passwordcontroller.text,
    );
    User? user = userCredential.user;
    if (user != null) {
      final uid = user.uid;
      final email = user.email ?? "";
      final username = email.split('@')[0];
      final photo = username.isNotEmpty ? username[0].toUpperCase() : "?";
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'email': email,
          'username': username,
          'photo': photo,
          'createdAt': Timestamp.now(),
        });
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successful login")));
    }
  } catch (e) { 
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
  
  }
  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }
  
}