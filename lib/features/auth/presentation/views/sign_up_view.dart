import 'package:flutter/material.dart';
import 'package:movie_verse_app/features/auth/presentation/views/widgets/sign_up_view_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SignUpViewBody());
  }
}
