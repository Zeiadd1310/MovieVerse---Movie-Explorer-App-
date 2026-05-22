import 'package:flutter/material.dart';

class RatingCard extends StatefulWidget {
  const RatingCard({super.key});

  @override
  State<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  int _currentRating = 4; // Default starting rating from design

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFFC107);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => setState(() => _currentRating = index + 1),
                icon: Icon(
                  index < _currentRating ? Icons.star : Icons.star_outline,
                  color: index < _currentRating ? accentColor : Colors.grey,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            '$_currentRating.0',
            style: const TextStyle(color: accentColor, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Tap a star to rate',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}