import 'package:flutter/material.dart';
import 'package:movie_verse_app/features/auth/presentation/views/widgets/sign_in_view_body.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      body: SignInViewBody(),
    );
  }
}
