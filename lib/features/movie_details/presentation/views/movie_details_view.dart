import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/widgets/custom_nav_bar.dart';
import 'package:movie_verse_app/core/widgets/custom_button.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Updated Colors to match close-ups exactly
    const accentColor = Color(0xFFF9B81F); 
    const slateText = Color(0xFF94A3B8); // Muted color for descriptions/labels
    const bgColor = Color(0xFFE1015); // Deep black/grey background

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 2. Scrollable Content Layer
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      // 3. Dynamic Font Handling for Interstellar Title
                      Text(
                        'Interstellar',
                        style: GoogleFonts.inter(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1.2, // Essential tight look
                        ),
                      ),
                      const SizedBox(height: 10),
                      // 4. Star Rating and Meta Info Row
                      Row(
                        children: [
                          const Icon(Icons.star, color: accentColor, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '4.8 (1.2M)  •  2h 49m  •  2014',
                            style: GoogleFonts.inter(
                              color: slateText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // 5. Clean Overview Section
                      _buildSectionTitle('Overview'),
                      const SizedBox(height: 12),
                      Text(
                        'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
                        style: GoogleFonts.inter(
                          color: slateText,
                          fontSize: 15,
                          height: 1.7,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 35),
                      // 6. Cast Section with Updated Avatars
                      _buildCastSection(accentColor, slateText),
                      const SizedBox(height: 140), // Large space for the floating button
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 7. Floating Watch Button with Glowing Shadow
          _buildFloatingWatchButton(accentColor),
        ],
      ),
      // 8. Custom Bottom Navigation to match images
     // bottomNavigationBar: _buildBottomNav(accentColor, slateText),
    );
  }

  // --- UI Component Methods ---

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Darkened space image
        Image.network(
          'https://image.tmdb.org/t/p/original/gEU2QniE6E77NI6vCU6mfsjvYv0.jpg',
          height: 500,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        // Subtle dark gradient for readability
        Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                const Color(0xFF0F1014),
              ],
            ),
          ),
        ),
        // Top Icon Buttons (Circular overlays)
        Positioned(
          top: 55,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleIcon(Icons.arrow_back),
              Row(
                children: [
                  _circleIcon(Icons.favorite_border),
                  const SizedBox(width: 15),
                  _circleIcon(Icons.share_outlined),
                ],
              ),
            ],
          ),
        ),
        // Badges positioned low on the image
        Positioned(
          bottom: 25,
          left: 20,
          child: Row(
            children: [
              _genreChip('SCI-FI', isYellow: true),
              const SizedBox(width: 8),
              _genreChip('ADVENTURE'),
              const SizedBox(width: 8),
              _genreChip('DRAMA'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCastSection(Color accentColor, Color slateText) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Top Cast'),
            Text('See All',
              style: GoogleFonts.inter(
                color: accentColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              )
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Using TMDB links for correct actor imagery
              _castAvatar('Matthew McConaughey', 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/e9pMgR7vYICkmv96SStpU308tS7.jpg', slateText),
              _castAvatar('Anne Hathaway', 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/7S9pS9m4N0fV0mU9zX6W1m4.jpg', slateText),
              _castAvatar('Jessica Chastain', 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/m8iYvY66SArzE0N3Eq9T0f6EqP7.jpg', slateText),
              _castAvatar('Michael Caine', 'https://www.themoviedb.org/t/p/w300_and_h450_bestv2/h9S68u8896ySZZZf36uX2kH5.jpg', slateText),
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets with Detailed Styling ---

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _genreChip(String label, {bool isYellow = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isYellow ? const Color(0xFFF9B81F) : const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isYellow ? Colors.black : Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w900, // Black Inter weight
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _castAvatar(String name, String imageUrl, Color slateText) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white12,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 12),
          Text(
            name.split(' ')[0],
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)
          ),
          Text(
            name.split(' ').last,
            style: GoogleFonts.inter(color: slateText, fontSize: 12)
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
    );
  }

 Widget _buildFloatingWatchButton(Color accentColor) {
  return Positioned(
    bottom: 30,
    left: 20,
    right: 20,

    child: CustomButton(
      text: 'Watch Now',

      width: double.infinity,
      height: 60,

      radius: 30,

      color: accentColor,

      icon: Icons.play_arrow_rounded,

      style: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 18,
        letterSpacing: -0.5,
      ),

      onTap: () {},
    ),
  );
}

  /*Widget _buildBottomNav(Color accentColor, Color slateText) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0F1014),
      selectedItemColor: accentColor,
      unselectedItemColor: slateText,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Watchlist'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }*/
}