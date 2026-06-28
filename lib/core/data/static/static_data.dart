import 'package:movie_verse_app/core/data/models/movie.dart';

/// Static placeholder data — replace with API + Cubit later.
abstract final class StaticData {
  static const categories = ['Action', 'Sci-Fi', 'Horror', 'Drama'];

  static const trendingSearches = [
    'Inception',
    'The Dark Knight',
    'Interstellar',
  ];

  static const featuredBanner = (
    image: 'assets/images/dune.jpg',
    badge: 'TRENDING',
    title: 'Dune: Part Two',
  );

  static const trendingMovies = [
    Movie(
      id: 'the-creator',
      title: 'The Creator',
      imageAsset: 'assets/images/creator.jpg',
      subtitle: 'Sci-Fi • 2023',
      rating: '8.5',
    ),
    Movie(
      id: 'oppenheimer',
      title: 'Oppenheimer',
      imageAsset: 'assets/images/oppenheimer.jpg',
      subtitle: 'History • 2023',
      rating: '9.1',
    ),
    Movie(
      id: 'tall-girl',
      title: 'Tall Girl',
      imageAsset: 'assets/images/tallgirl.jpg',
      subtitle: 'Drama • 2022',
      rating: '7.8',
    ),
  ];

  static const popularMovies = [
    Movie(
      id: 'interstellar',
      title: 'Interstellar',
      imageAsset: 'assets/images/interstellar.jpg',
      subtitle: 'Adventure, Drama, Sci-Fi',
      rating: '8.7',
      genres: 'Adventure, Drama, Sci-Fi',
    ),
    Movie(
      id: 'john-wick',
      title: 'John Wick',
      imageAsset: 'assets/images/johnwick.jpg',
      subtitle: 'Action, Crime',
      rating: '9.0',
      genres: 'Action, Crime',
    ),
  ];

  static const searchResults = [
    Movie(
      id: 'the-creator-1',
      title: 'The Creator',
      imageAsset: 'assets/images/creator1.jpg',
      subtitle: '2023 • Sci-Fi',
      rating: '8.4',
    ),
    Movie(
      id: 'peak-of-destiny',
      title: 'Peak of Destiny',
      imageAsset: 'assets/images/peak.jpg',
      subtitle: '2024 • Adventure',
      rating: '7.9',
    ),
    Movie(
      id: 'midnight-rhythm',
      title: 'Midnight Rhythm',
      imageAsset: 'assets/images/midnight.jpg',
      subtitle: '2022 • Musical',
      rating: '9.1',
    ),
    Movie(
      id: 'singularity',
      title: 'Singularity',
      imageAsset: 'assets/images/singularity.jpg',
      subtitle: '2024 • Documentary',
      rating: '8.6',
    ),
    Movie(
      id: 'the-silent-page',
      title: 'The Silent Page',
      imageAsset: 'assets/images/silent.jpg',
      subtitle: '2021 • Mystery',
      rating: '7.5',
    ),
    Movie(
      id: 'projector',
      title: 'Projector',
      imageAsset: 'assets/images/projector.jpg',
      subtitle: '2023 • Thriller',
      rating: '8.2',
    ),
  ];

  static const interstellar = MovieDetails(
    id: 'interstellar',
    title: 'Interstellar',
    imageAsset: 'assets/images/interstellar.jpg',
    subtitle: 'Adventure, Drama, Sci-Fi',
    rating: '4.8',
    overview:
        'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
    meta: '4.8 (1.2M)  •  2h 49m  •  2014',
    genreTags: ['SCI-FI', 'ADVENTURE', 'DRAMA'],
    director: 'Christopher Nolan',
    year: '2014',
    cast: [
      CastMember(
        name: 'Matthew McConaughey',
        imageAsset: 'assets/images/creator.jpg',
      ),
      CastMember(
        name: 'Anne Hathaway',
        imageAsset: 'assets/images/creator1.jpg',
      ),
      CastMember(
        name: 'Jessica Chastain',
        imageAsset: 'assets/images/peak.jpg',
      ),
      CastMember(
        name: 'Michael Caine',
        imageAsset: 'assets/images/midnight.jpg',
      ),
    ],
  );

  static const reviewTags = [
    'Visual Effects',
    'Acting',
    'Soundtrack',
    'Cinematography',
  ];

  static MovieDetails movieById(String id) {
    if (id == interstellar.id) return interstellar;
    return interstellar;
  }
}
