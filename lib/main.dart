import 'package:chat_app/landing/page/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, dark, child){
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            home: const TravelLandingPage(),
        );
      },
      
    );
  }
}

