class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.subtitle,
    required this.rating,
    this.genres,
  });

  final String id;
  final String title;
  final String imageAsset;
  final String subtitle;
  final String rating;
  final String? genres;
}

class CastMember {
  const CastMember({required this.name, required this.imageAsset});

  final String name;
  final String imageAsset;
}

class MovieDetails extends Movie {
  const MovieDetails({
    required super.id,
    required super.title,
    required super.imageAsset,
    required super.subtitle,
    required super.rating,
    required this.overview,
    required this.meta,
    required this.genreTags,
    required this.cast,
    this.director,
    this.year,
  });

  final String overview;
  final String meta;
  final List<String> genreTags;
  final List<CastMember> cast;
  final String? director;
  final String? year;
}
