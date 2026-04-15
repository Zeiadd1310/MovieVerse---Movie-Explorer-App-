import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import this!
import 'package:movie_verse_app/features/movie_details/presentation/views/movie_details_view.dart';

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
        // This applies Inter to the entire app's text system
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      home: MovieDetailsScreen(),
    );
  }
}