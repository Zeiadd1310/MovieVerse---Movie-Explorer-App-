import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_verse_app/core/constants/constants.dart';
import 'package:movie_verse_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:movie_verse_app/features/profile/presentation/cubits/profile_state.dart';

class EditProfileViewBody extends StatefulWidget {
  const EditProfileViewBody({super.key});

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  static const _backgroundColor = Color(0xFF0E1015);
  static const _textPrimary = Color(0xFFF1F5F9);
  static const _fieldBackground = Color(0xFF1A1D24);
  static const _fieldBorder = Color(0xFF2D323D);
  static const _labelColor = Color(0xFFCBD5E1);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();

  File? _pickedImage;
  String? _existingPhotoUrl;
  bool _prefilled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _save(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<ProfileCubit>().saveProfile(
      uid: uid,
      fullName: _nameController.text.trim(),
      bio: _bioController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaved) {
          context.pop();
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
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
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded && !_prefilled) {
              _nameController.text = state.profile.fullName;
              _emailController.text = state.profile.email;
              _bioController.text = state.profile.bio;
              _existingPhotoUrl = state.profile.photoUrl;
              _prefilled = true;
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError && !_prefilled) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final isSaving = state is ProfileSaving;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(32.r),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 128.w,
                                height: 128.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: kButtonsColor.withValues(alpha: 0.2),
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                    image: _pickedImage != null
                                        ? FileImage(_pickedImage!)
                                              as ImageProvider
                                        : (_existingPhotoUrl != null &&
                                              _existingPhotoUrl!.isNotEmpty)
                                        ? NetworkImage(_existingPhotoUrl!)
                                        : const NetworkImage(
                                            'https://i.pravatar.cc/256?img=13',
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: kButtonsColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _backgroundColor,
                                      width: 4,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: _backgroundColor,
                                    size: 15.sp,
                                  ),
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
                          enabled: false,
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
                            onTap: isSaving ? null : () => _save(context),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: isSaving
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
            );
          },
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
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final Color fieldBackground;
  final Color fieldBorder;
  final Color labelColor;
  final Color textColor;
  final TextInputType keyboardType;
  final bool enabled;

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
            enabled: enabled,
            textAlignVertical: TextAlignVertical.center,
            style: GoogleFonts.splineSans(
              color: enabled ? textColor : textColor.withValues(alpha: 0.5),
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              isDense: true,
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
