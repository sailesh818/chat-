import 'package:chat_app/login/page/login_page.dart';
import 'package:chat_app/profile/page/profile_page.dart';
import 'package:chat_app/settings/page/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out successfully.")),);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out Error")),);

    }
  }
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const ListTile(title: Text("Home")),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfilePage()));
            },
            child: const ListTile(title: Text("Profile"))),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=> SettingsPage()));
            },
            child: const ListTile(title: Text("Settings"))),
          InkWell(
            onTap: ()=> logout(context),
            child: const ListTile(title: Text("LogOut"))),
        ],
      ),
    );
  }
}

