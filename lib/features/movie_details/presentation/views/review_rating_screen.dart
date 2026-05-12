import 'package:flutter/material.dart';
import 'package:movie_verse_app/widgets/movie_card.dart';
import 'package:movie_verse_app/widgets/rating_card.dart';

class ReviewRatingScreen extends StatefulWidget {
  const ReviewRatingScreen({super.key});

  @override
  State<ReviewRatingScreen> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewRatingScreen> {
  // State variables to keep track of user input
  bool _isSpoiler = false;
  final List<String> _selectedTags = [];
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Standardized colors from the design
    const backgroundColor = Color(0xFF121214);
    const cardColor = Color(0xFF1C1C1E);
    const accentColor = Color(0xFFFFC107);
    const chipColor = Color(0xFF2C2C2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: chipColor, // Circular background for arrow
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Write a Review',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Info Card
            const MovieCard(),
            
            const SizedBox(height: 30),
            const Text(
              'How was the movie?', 
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 12),
            
            // Interactive Star Rating Widget
            const RatingCard(),
            
            const SizedBox(height: 30),
            
            // Review Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Review', 
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                ),
                Text('Optional', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            
            // Text Input Field
            TextField(
              controller: _reviewController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'What did you think of the story, acting, and visuals?',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                fillColor: cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), 
                  borderSide: BorderSide.none
                ),
                counterText: '${_reviewController.text.length} / 1000',
                counterStyle: const TextStyle(color: Colors.grey),
              ),
              onChanged: (value) => setState(() {}), // Update character counter
            ),
            
            const SizedBox(height: 25),
            const Text(
              'WHAT STOOD OUT?', 
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 12),
            
            // Interactive Feature Chips (Actual Buttons)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Visual Effects', 
                'Acting', 
                'Soundtrack', 
                'Cinematography'
              ].map((label) {
                bool isSelected = _selectedTags.contains(label);
                return FilterChip(
                  label: Text(label),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      selected ? _selectedTags.add(label) : _selectedTags.remove(label);
                    });
                  },
                  backgroundColor: chipColor,
                  selectedColor: accentColor,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: isSelected ? accentColor : Colors.transparent),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Spoiler Toggle Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor, 
                borderRadius: BorderRadius.circular(16)
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contain Spoilers?', 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                        Text(
                          'Hide review from others', 
                          style: TextStyle(color: Colors.grey, fontSize: 11)
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isSpoiler, 
                    onChanged: (val) => setState(() => _isSpoiler = val),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            // Final Submit Button
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  // Action for submitting
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Review', 
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.play_arrow_outlined, color: Colors.black, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}