import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_verse_app/core/constants/constants.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  static const _backgroundColor = Color(0xFF0E1015);
  static const _textPrimary = Color(0xFFF1F5F9);
  static const _fieldBackground = Color(0xFF1A1D24);
  static const _fieldBorder = Color(0xFF2D323D);
  static const _labelColor = Color(0xFFCBD5E1);

  late final _nameController = TextEditingController(text: 'Alex Thompson');
  late final _emailController = TextEditingController(
    text: 'alex.thompson@cinema.com',
  );
  late final _bioController = TextEditingController(
    text:
        'Movie enthusiast, popcorn addict, and amateur film critic. Obsessed '
        'with 90s noir and modern sci-fi epics. Always looking for the next '
        'hidden gem.',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(73.h),
        child: Container(
          decoration: const BoxDecoration(
            color: _backgroundColor,
            border: Border(bottom: BorderSide(color: _fieldBorder)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: _textPrimary,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Edit Profile',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.splineSans(
                        color: _textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(32.r),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 128.w,
                        height: 128.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kButtonsColor.withValues(alpha: 0.2),
                            width: 4,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.pravatar.cc/256?img=13',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: kButtonsColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: _backgroundColor, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            color: _backgroundColor,
                            size: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'CHANGE PROFILE PICTURE',
                    style: GoogleFonts.splineSans(
                      color: kButtonsColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.35,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              child: Column(
                children: [
                  _FormField(
                    label: 'Full Name',
                    controller: _nameController,
                    icon: Icons.person_outline,
                    fieldBackground: _fieldBackground,
                    fieldBorder: _fieldBorder,
                    labelColor: _labelColor,
                    textColor: _textPrimary,
                  ),
                  SizedBox(height: 16.h),
                  _FormField(
                    label: 'Email Address',
                    controller: _emailController,
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    fieldBackground: _fieldBackground,
                    fieldBorder: _fieldBorder,
                    labelColor: _labelColor,
                    textColor: _textPrimary,
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                        child: Text(
                          'Bio',
                          style: GoogleFonts.splineSans(
                            color: _labelColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: _fieldBackground,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: _fieldBorder),
                        ),
                        child: TextField(
                          controller: _bioController,
                          maxLines: 4,
                          style: GoogleFonts.splineSans(
                            color: _textPrimary,
                            fontSize: 16.sp,
                            height: 26 / 16,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              child: Column(
                children: [
                  Material(
                    color: kButtonsColor,
                    borderRadius: BorderRadius.circular(24.r),
                    elevation: 6,
                    shadowColor: kButtonsColor.withValues(alpha: 0.3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24.r),
                      onTap: () => context.pop(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_outlined,
                              color: _backgroundColor,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Save Changes',
                              style: GoogleFonts.splineSans(
                                color: _backgroundColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Discard Changes',
                      style: GoogleFonts.splineSans(
                        color: kSlateText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.fieldBackground,
    required this.fieldBorder,
    required this.labelColor,
    required this.textColor,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final Color fieldBackground;
  final Color fieldBorder;
  final Color labelColor;
  final Color textColor;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: GoogleFonts.splineSans(
              color: labelColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: fieldBackground,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: fieldBorder),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.splineSans(color: textColor, fontSize: 16.sp),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 17.w),
              prefixIcon: Icon(icon, color: kSlateText, size: 16.sp),
            ),
          ),
        ),
      ],
    );
  }
}
