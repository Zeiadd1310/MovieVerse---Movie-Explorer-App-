import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_cubit.dart';

import 'widgets/privacy_view_body.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepoImpl()),
      child: const PrivacyViewBody(),
    );
  }
}
