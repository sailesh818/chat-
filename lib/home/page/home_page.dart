import 'package:chat_app/login/page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logout(BuildContext context) async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out successfully.")),);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out Error")),);

    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
        onTap:()=> logout(context),
        child: Text("Log Out")),
      ),
    );
  }
}