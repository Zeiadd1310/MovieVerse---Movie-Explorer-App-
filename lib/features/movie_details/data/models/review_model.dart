class ReviewModel {
  final int movieId;
  final String title;
  final double rating;
  final String review;

  ReviewModel({
    required this.movieId,
    required this.title,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'title': title,
      'rating': rating,
      'review': review,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      movieId: map['movieId'] as int,
      title: map['title'] as String,
      rating: (map['rating'] as num).toDouble(),
      review: map['review'] as String,
    );
  }
}