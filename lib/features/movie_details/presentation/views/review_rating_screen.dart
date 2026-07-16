import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/widgets/movie_card.dart';
import 'package:movie_verse_app/widgets/rating_card.dart';
import 'package:movie_verse_app/features/movie_details/data/models/movie_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/movie_details/data/models/review_model.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/review_cubit.dart';
import 'package:movie_verse_app/features/movie_details/presentation/cubits/review_state.dart';

class ReviewRatingScreen extends StatefulWidget {
  final MovieDetailsModel movie;

  const ReviewRatingScreen({super.key, required this.movie});

  @override
  State<ReviewRatingScreen> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewRatingScreen> {
  double _rating = 0;
  bool _isEditing = false;
  bool _isSubmitting = false;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null && mounted) {
        context.read<ReviewCubit>().getReview(
          userId: userId,
          movieId: widget.movie.id,
        );
      }
    });
  }

  void _applyExistingReview(ReviewModel review) {
    _rating = review.rating;
    _reviewController.text = review.review;
    _isEditing = true;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF121214);
    const cardColor = Color(0xFF1C1C1E);
    const chipColor = Color(0xFF2C2C2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: chipColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 18.sp),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit Review' : 'Write a Review',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess && state.review != null && !_isEditing) {
            setState(() => _applyExistingReview(state.review!));
          } else if (state is ReviewSubmitted) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Review submitted successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context); // Close page after success
          } else if (state is ReviewError) {
            setState(() => _isSubmitting = false);
            // Displays a dialog on screen if Firebase returns an error
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: cardColor,
                title: const Text(
                  "Submission Failed",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  state.errMessage,
                  style: const TextStyle(color: Colors.grey),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: kButtonsColor),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MovieCard(movie: widget.movie),
                    SizedBox(height: 30.h),
                    Text(
                      'How was the movie?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    RatingCard(
                      rating: _rating,
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Optional',
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _reviewController,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText:
                            'What did you think of the story, acting, and visuals?',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                        fillColor: cardColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        counterText: '${_reviewController.text.length} / 1000',
                        counterStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      height: 58.h,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null // Disable button while loading
                            : () {
                                final currentUser =
                                    FirebaseAuth.instance.currentUser;
                                if (currentUser == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'You must be logged in to submit a review.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final review = ReviewModel(
                                  movieId: widget.movie.id,
                                  title: widget.movie.title,
                                  rating: _rating,
                                  review: _reviewController.text,
                                );

                                setState(() => _isSubmitting = true);
                                context.read<ReviewCubit>().submitReview(
                                  userId: currentUser.uid,
                                  review: review,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonsColor,
                          elevation: 5,
                          shadowColor: Colors.black.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSubmitting ? 'Submitting...' : 'Submit Review',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            if (!_isSubmitting)
                              Icon(
                                Icons.play_arrow_outlined,
                                color: Colors.black,
                                size: 20.sp,
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              // Full Screen Blur/Loading indicator block when active
              if (_isSubmitting)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: kButtonsColor),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
