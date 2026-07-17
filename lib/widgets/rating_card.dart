import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_verse_app/core/constants/constants.dart';

class RatingCard extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  final int maxStars;

  const RatingCard({
    super.key,
    required this.rating,
    required this.onChanged,
    this.maxStars = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxStars, (index) {
              final starValue = index + 1;
              return Expanded(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                  onPressed: () => onChanged(starValue.toDouble()),
                  icon: Icon(
                    starValue <= rating ? Icons.star : Icons.star_outline,
                    color: starValue <= rating ? kButtonsColor : Colors.grey,
                    size: 26.sp,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: kButtonsColor,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tap a star to rate (1–$maxStars)',
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
