import 'package:flutter/material.dart';
// Ensure this path is where the Review UI code is saved
import 'package:movie_verse_app/features/movie_details/presentation/views/review_rating_screen.dart';

void main() {
  runApp(const MovieVerseApp());
}

class MovieVerseApp extends StatelessWidget {
  const MovieVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      // CHANGE THIS to the exact class name inside review_rating_screen.dart
      // If you used the code I gave you earlier, it is likely 'ReviewPage'
      home: const ReviewPage(), 
    );
  }
}