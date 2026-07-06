import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/core/data/static/static_data.dart';
import 'package:movie_verse_app/widgets/movie_card.dart';
import 'package:movie_verse_app/widgets/rating_card.dart';

class ReviewRatingScreen extends StatefulWidget {
  const ReviewRatingScreen({super.key});

  @override
  State<ReviewRatingScreen> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewRatingScreen> {
  bool _isSpoiler = false;
  final List<String> _selectedTags = [];
  final TextEditingController _reviewController = TextEditingController();

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
          'Write a Review',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MovieCard(),
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
            const RatingCard(),
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
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                fillColor: cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                counterText: '${_reviewController.text.length} / 1000',
                counterStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 25.h),
            Text(
              'WHAT STOOD OUT?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: StaticData.reviewTags.map((label) {
                final isSelected = _selectedTags.contains(label);
                return FilterChip(
                  label: Text(label),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 12.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selected
                          ? _selectedTags.add(label)
                          : _selectedTags.remove(label);
                    });
                  },
                  backgroundColor: chipColor,
                  selectedColor: kButtonsColor,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: isSelected ? kButtonsColor : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contain Spoilers?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          'Hide review from others',
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isSpoiler,
                    onChanged: (val) => setState(() => _isSpoiler = val),
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 58.h,
              child: ElevatedButton(
                onPressed: () {},
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
                      'Submit Review',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
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
    );
  }
}
