import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:movie_verse_app/features/auth/presentation/views/widgets/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepoImpl()),
      child: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: SignUpViewBody(),
      ),
    );
  }
}
