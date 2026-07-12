import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/auth/data/repos/auth_repo.dart';
import 'package:movie_verse_app/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepo.signIn(email: email, password: password);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    emit(AuthLoading());
    final result = await authRepo.forgotPassword(email: email);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(ForgotPasswordEmailSent()),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(AuthLoading());
    final result = await authRepo.signInWithFacebook();
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
