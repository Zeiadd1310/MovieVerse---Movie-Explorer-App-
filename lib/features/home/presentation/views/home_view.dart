import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0F1A),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff111827),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: "Watchlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TOP BAR
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [

                        const Icon(
                          Icons.movie,
                          color: Colors.amber,
                          size: 20,
                        ),

                        const SizedBox(width: 8),

                        const Text(
                          "MovieExplorer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xff1C2333),
                            borderRadius:
                                BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xff1C2333),
                            borderRadius:
                                BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// BANNER
                Container(
                  height: 210,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/images/dune.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),

                  child: Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),

                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,

                        colors: [
                          Colors.black.withOpacity(.9),
                          Colors.transparent,
                        ],
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      mainAxisAlignment:
                          MainAxisAlignment.end,

                      children: [

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),

                          child: const Text(
                            "TRENDING",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Text(
                          "Dune: Part Two",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    BorderRadius.circular(
                                        30),
                              ),

                              child: const Row(
                                children: [

                                  Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                    size: 18,
                                  ),

                                  SizedBox(width: 5),

                                  Text(
                                    "Watch Now",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              height: 44,
                              width: 44,

                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withOpacity(.2),
                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// CATEGORIES
                sectionTitle("Categories"),

                const SizedBox(height: 15),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    children: [

                      categoryItem("Action", true),

                      categoryItem("Sci-Fi", false),

                      categoryItem("Horror", false),

                      categoryItem("Drama", false),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// TRENDING
                sectionTitle("Trending Now"),

                const SizedBox(height: 18),

                SizedBox(
                  height: 270,

                  child: ListView(
                    scrollDirection: Axis.horizontal,

                    children: [

                      trendingCard(
                        "assets/images/creator.jpg",
                        "The Creator",
                        "Sci-Fi • 2023",
                        "8.5",
                      ),

                      const SizedBox(width: 15),

                      trendingCard(
                        "assets/images/oppenheimer.jpg",
                        "Oppenheimer",
                        "History • 2023",
                        "9.1",
                      ),

                      const SizedBox(width: 15),

                      trendingCard(
                        "assets/images/tallgirl.jpg",
                        "Tall Girl",
                        "Drama • 2022",
                        "7.8",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// POPULAR MOVIES
                sectionTitle("Popular Movies"),

                const SizedBox(height: 18),

                popularMovieCard(
                  "assets/images/interstellar.jpg",
                  "Interstellar",
                  "Adventure, Drama, Sci-Fi",
                  "8.7",
                ),

                const SizedBox(height: 15),

                popularMovieCard(
                  "assets/images/johnwick.jpg",
                  "John Wick",
                  "Action, Crime",
                  "9.0",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Text(
          "See all",
          style: TextStyle(
            color: Colors.amber,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget categoryItem(
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
            : const Color(0xff1C2333),

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

  Widget trendingCard(
    String image,
    String title,
    String subtitle,
    String rating,
  ) {
    return Container(
      width: 150,

      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Stack(
            children: [

              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),

                child: Image.asset(
                  image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 10,
                right: 10,

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Text(
                    rating,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget popularMovieCard(
    String image,
    String title,
    String genre,
    String rating,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [

          ClipRRect(
            borderRadius:
                BorderRadius.circular(15),

            child: Image.asset(
              image,
              height: 85,
              width: 65,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  genre,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.bookmark_border,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}