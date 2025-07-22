import 'package:chat_app/controllers/login_page_provider.dart';
import 'package:chat_app/view/login/page/create_account_page.dart';
import 'package:chat_app/view/login/page/forgot_password_page.dart';
import 'package:chat_app/view/login/widget/auth_button.dart';
import 'package:chat_app/view/login/widget/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginPageProvider(),
      child: Consumer<LoginPageProvider>(
        builder: (context, loginPageProvider, _) {
          return Scaffold(
            appBar: AppBar(title: Text("Login Page"),),
            body: ListView(
              children: [
                AuthTextField(controller: loginPageProvider.emailcontroller, label: "Email"),
                SizedBox(height: 10,),
                AuthTextField(controller: loginPageProvider.passwordcontroller, label: "Password", obscure: false),
                Padding(
                  padding: const EdgeInsets.only(left: 200, top: 4),
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
                    child: const Text("Forgot Password", style: TextStyle(color: Colors.blue)),
                  ),
                ),
                SizedBox(height: 10,),
                AuthButton(text: "Login", onPressed: () => loginPageProvider.login(context)),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Are you new?"),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> CreateAccountPage()));
                    },
                    child: Text("Create Account", style: TextStyle(color: Colors.blue),))
                ],)
              ],
            ),
          );
        }
      ),
    );
  }
}