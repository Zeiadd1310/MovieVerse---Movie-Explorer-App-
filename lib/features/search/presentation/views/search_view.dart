import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0F1A),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff111827),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        elevation: 0,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "HOME",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "SEARCH",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: "WATCHLIST",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "PROFILE",
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// HEADER
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    "Explorer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(
                      "assets/images/profile.jpg",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// SEARCH BAR
              Container(
                height: 55,

                decoration: BoxDecoration(
                  color: const Color(0xff151C2C),
                  borderRadius:
                      BorderRadius.circular(30),
                ),

                child: const TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),

                    hintText: "Search movies...",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// TRENDING SEARCHES
              const Text(
                "Trending Searches",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(
                  children: [

                    searchChip(
                      "Inception",
                      true,
                    ),

                    searchChip(
                      "The Dark Knight",
                      false,
                    ),

                    searchChip(
                      "Interstellar",
                      false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// RESULTS
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    "Results",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "1,240 MOVIES",
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.58,

                  children: [

                    movieCard(
                      "assets/images/creator1.jpg",
                      "The Creator",
                      "2023 • Sci-Fi",
                      "8.4",
                    ),

                    movieCard(
                      "assets/images/peak.jpg",
                      "Peak of Destiny",
                      "2024 • Adventure",
                      "7.9",
                    ),

                    movieCard(
                      "assets/images/midnight.jpg",
                      "Midnight Rhythm",
                      "2022 • Musical",
                      "9.1",
                    ),

                    movieCard(
                      "assets/images/singularity.jpg",
                      "Singularity",
                      "2024 • Documentary",
                      "8.6",
                    ),

                    movieCard(
                      "assets/images/silent.jpg",
                      "The Silent Page",
                      "2021 • Mystery",
                      "7.5",
                    ),

                    movieCard(
                      "assets/images/projector.jpg",
                      "Projector",
                      "2023 • Thriller",
                      "8.2",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchChip(
    String text,
    bool selected,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 10),

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: selected
            ? Colors.amber
            : const Color(0xff151C2C),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style: TextStyle(
          color:
              selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget movieCard(
    String image,
    String title,
    String subtitle,
    String rating,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Expanded(
          child: Stack(
            children: [

              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(24),

                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xff1A1A1A),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}