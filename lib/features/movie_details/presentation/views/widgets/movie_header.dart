/*import 'package:flutter/material.dart';

class MovieHeader extends StatelessWidget {
  const MovieHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Image.network(
          'https://via.placeholder.com/600x800', // Replace with Interstellar poster
          height: 450,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        // Gradient overlay for text readability
        Container(
          height: 450,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, const Color(0xFF121214).withOpacity(0.8), const Color(0xFF121214)],
            ),
          ),
        ),
        // Top Action Buttons
        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(Icons.arrow_back),
              Row(
                children: [
                  _circleButton(Icons.favorite_border),
                  const SizedBox(width: 10),
                  _circleButton(Icons.share),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}*/