import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html; // Import for web
import 'package:simple_animated_button/simple_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF87CEFA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Stroke
                Text(
                  'GRIDLOCK',
                  style: GoogleFonts.barriecito(
                    textStyle: TextStyle(
                      fontSize: 92.0,
                      fontWeight: FontWeight.w900, // Thicker font weight
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3.0 // Thicker stroke width
                        ..color = Colors.black, // Border color
                    ),
                  ),
                ),
                // Fill
                Text(
                  'GRIDLOCK',
                  style: GoogleFonts.barriecito(
                    textStyle: TextStyle(
                      fontSize: 92.0,
                      fontWeight: FontWeight.w900, // Thicker font weight
                      color: Colors.white, // Text fill color
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedLayerButton(
              onClick: () {
                Navigator.pushNamed(context, '/game');
              },
              buttonHeight: 60,
              buttonWidth: 270,
              animationDuration: const Duration(milliseconds: 200),
              animationCurve: Curves.ease,
              topDecoration: BoxDecoration(
                color: Colors.amber,
                border: Border.all(),
              ),
              topLayerChild: const Text(
                "Play",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              baseDecoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedLayerButton(
              onClick: () {
                Navigator.pushNamed(context, '/settings');
              },
              buttonHeight: 60,
              buttonWidth: 270,
              animationDuration: const Duration(milliseconds: 200),
              animationCurve: Curves.ease,
              topDecoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
              ),
              topLayerChild: const Text(
                "Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              baseDecoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}