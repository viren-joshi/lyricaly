import 'package:flutter/material.dart';
import 'package:lyricaly/screens/home_screen.dart';
import 'package:lyricaly/services/connectivity_handler.dart';

// 81dff9e8b6b4940268e0ddd4dcac1fdf

void main() {
  runApp(const Lyricaly());
}

class Lyricaly extends StatelessWidget {
  const Lyricaly({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }


}
