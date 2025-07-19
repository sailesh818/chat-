import 'package:chat_app/login/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelLandingPage extends StatefulWidget {
  const TravelLandingPage({super.key});

  @override
  State<TravelLandingPage> createState() => _TravelLandingPageState();
}

class _TravelLandingPageState extends State<TravelLandingPage> with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _imageController;
  Animation<double>? _textAnimation;
  Animation<double>? _imageFadeAnimation;
  Animation<Offset>? _imageSlideAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _imageFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeInOut),
    );

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,          
    ).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
    );
    _textController.forward();
    _imageController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final textOpacity = _textAnimation ?? AlwaysStoppedAnimation(0);
    final imageOpacity = _imageFadeAnimation ?? AlwaysStoppedAnimation(0);
    final imageSlide = _imageSlideAnimation ?? Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_imageController);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FadeTransition(
            opacity: imageOpacity,
            child: SlideTransition(
              position: imageSlide,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/hero.jpeg",
                  height: screenHeight * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: textOpacity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Explore the World",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Discover new places, plan your trip, and experience adventures.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Get Started"),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}