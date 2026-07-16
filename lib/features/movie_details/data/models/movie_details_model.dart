class MovieDetailsModel {
  final bool adult;
  final String? backdropPath;
  final BelongsToCollectionModel? belongsToCollection;
  final int budget;
  final List<GenreModel> genres;
  final String? homepage;
  final int id;
  final String? imdbId;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<ProductionCompanyModel> productionCompanies;
  final List<ProductionCountryModel> productionCountries;
  final String releaseDate;
  final int revenue;
  final int runtime;
  final List<SpokenLanguageModel> spokenLanguages;
  final String status;
  final String? tagline;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final List<CastMember> cast;

  MovieDetailsModel({
    required this.adult,
    this.backdropPath,
    this.belongsToCollection,
    required this.budget,
    required this.genres,
    this.homepage,
    required this.id,
    this.imdbId,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.cast,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'],
      belongsToCollection: json['belongs_to_collection'] != null
          ? BelongsToCollectionModel.fromJson(json['belongs_to_collection'])
          : null,
      budget: json['budget'] ?? 0,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((e) => GenreModel.fromJson(e))
          .toList(),
      homepage: json['homepage'],
      id: json['id'] ?? 0,
      imdbId: json['imdb_id'],
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'],
      productionCompanies:
          (json['production_companies'] as List<dynamic>? ?? [])
              .map((e) => ProductionCompanyModel.fromJson(e))
              .toList(),
      productionCountries:
          (json['production_countries'] as List<dynamic>? ?? [])
              .map((e) => ProductionCountryModel.fromJson(e))
              .toList(),
      releaseDate: json['release_date'] ?? '',
      revenue: json['revenue'] ?? 0,
      runtime: json['runtime'] ?? 0,
      spokenLanguages: (json['spoken_languages'] as List<dynamic>? ?? [])
          .map((e) => SpokenLanguageModel.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
      tagline: json['tagline'],
      title: json['title'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      // Cast lives inside credits.cast because we request
      // append_to_response=credits in the same API call (see repo).
      cast: ((json['credits']?['cast'] as List<dynamic>?) ?? [])
          .map((e) => CastMember.fromJson(e))
          .toList(),
    );
  }

  // ---- Convenience getters for UI ----

  /// Full poster URL, e.g. for use in Image.network()
  String get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  /// Full backdrop URL
  String get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : '';

  /// Comma-separated genre names, e.g. "Adventure, Action, Science Fiction"
  String get genreNames => genres.map((g) => g.name).join(', ');

  /// Formatted runtime, e.g. "2h 1m"
  String get formattedRuntime {
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}h ${minutes}m';
  }

  /// Release year only, e.g. "1977"
  String get releaseYear =>
      releaseDate.isNotEmpty ? releaseDate.split('-').first : '';

  /// Formatted budget, e.g. "$11,000,000"
  String get formattedBudget => _formatCurrency(budget);

  /// Formatted revenue, e.g. "$775,398,007"
  String get formattedRevenue => _formatCurrency(revenue);

  /// Vote average rounded to 1 decimal, e.g. "8.2"
  String get formattedRating => voteAverage.toStringAsFixed(1);

  Map<String, dynamic> toFavoriteMap() => {
    'id': id.toString(),
    'title': title,
    'subtitle': '$genreNames • $releaseYear',
    'rating': formattedRating,
    'image': fullPosterUrl,
  };

  /// Whether this movie belongs to a franchise/collection
  bool get hasCollection => belongsToCollection != null;

  /// Top-billed cast only, sorted by TMDB's own `order` field, capped at 10.
  /// Use this directly for a "Top Cast" horizontal list.
  List<CastMember> get topCast {
    final sorted = List<CastMember>.from(cast)
      ..sort((a, b) => a.order.compareTo(b.order));
    return sorted.take(10).toList();
  }

  String _formatCurrency(int amount) {
    if (amount == 0) return 'N/A';
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return '\$$buffer';
  }
}

class BelongsToCollectionModel {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;

  BelongsToCollectionModel({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
  });

  factory BelongsToCollectionModel.fromJson(Map<String, dynamic> json) {
    return BelongsToCollectionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
    );
  }
}

class GenreModel {
  final int id;
  final String name;

  GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class ProductionCompanyModel {
  final int id;
  final String? logoPath;
  final String name;
  final String? originCountry;

  ProductionCompanyModel({
    required this.id,
    this.logoPath,
    required this.name,
    this.originCountry,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) {
    return ProductionCompanyModel(
      id: json['id'] ?? 0,
      logoPath: json['logo_path'],
      name: json['name'] ?? '',
      originCountry: json['origin_country'],
    );
  }
}

class ProductionCountryModel {
  final String iso31661;
  final String name;

  ProductionCountryModel({required this.iso31661, required this.name});

  factory ProductionCountryModel.fromJson(Map<String, dynamic> json) {
    return ProductionCountryModel(
      iso31661: json['iso_3166_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SpokenLanguageModel {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguageModel({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguageModel.fromJson(Map<String, dynamic> json) {
    return SpokenLanguageModel(
      englishName: json['english_name'] ?? '',
      iso6391: json['iso_639_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
    required this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
      order: json['order'] ?? 0,
    );
  }

  /// Network equivalent of your StaticData CastMember's `imageAsset`
  String get fullProfileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w300$profilePath' : '';
}
