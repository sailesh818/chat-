import 'package:chat_app/login/page/login_page.dart';
import 'package:chat_app/login/widget/auth_button.dart';
import 'package:chat_app/login/widget/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailcontroller = TextEditingController();

  Future<void> send(BuildContext context) async{
    final email = emailcontroller.text.trim();

    if(email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter your email")),);
      return;
    }
    
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Reset Email sent successfully")));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unsuccessfull ${"error"}")));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: ListView(
        padding: const EdgeInsets.only(top: 50),
        children: [
          AuthTextField(controller: emailcontroller, label: "Email"),
          const SizedBox(height: 25),
          AuthButton(text: "Send Link", onPressed: () => send(context)),
        ],
      ),
    );
  }
}