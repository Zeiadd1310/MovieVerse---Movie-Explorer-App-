import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/profile/data/repos/profile_repo_impl.dart';
import 'package:movie_verse_app/features/profile/presentation/cubits/profile_cubit.dart';

import 'widgets/edit_profile_view_body.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepoImpl())..loadProfile(uid),
      child: const EditProfileViewBody(),
    );
  }
}
