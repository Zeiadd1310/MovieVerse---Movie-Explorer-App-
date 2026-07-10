import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_cubit.dart';

import 'widgets/forgot_password_view_body.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepoImpl()),
      child: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: ForgotPasswordViewBody(),
      ),
    );
  }
}
