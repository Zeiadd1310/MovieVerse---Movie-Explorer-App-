import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_verse_app/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  Future<void> signOut();

  User? getCurrentUser();

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, User>> signInWithFacebook();

  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
