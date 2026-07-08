import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_verse_app/core/errors/failures.dart';
import 'package:movie_verse_app/features/auth/data/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(fullName);
      return Right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapSignUpError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _mapSignUpError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email. Try signing in instead.';
      case 'weak-password':
        return 'This password is too weak. Use at least 6 characters, mixing letters and numbers.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password sign up is currently disabled. Contact support.';
      default:
        return e.message ?? 'Sign up failed. Please try again.';
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapSignInError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _mapSignInError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'invalid-credential':
        return 'Incorrect email or password.';
      default:
        return e.message ?? 'Sign in failed. Please try again.';
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapForgotPasswordError(e)));
    }
  }

  String _mapForgotPasswordError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return e.message ?? 'Failed to send reset email. Please try again.';
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
