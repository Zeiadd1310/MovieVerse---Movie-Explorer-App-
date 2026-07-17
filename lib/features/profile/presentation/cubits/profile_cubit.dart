import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_verse_app/features/profile/data/repos/profile_repo.dart';
import 'package:movie_verse_app/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> loadProfile(String uid) async {
    emit(ProfileLoading());
    final result = await profileRepo.getProfile(uid: uid);
    result.fold(
      (failure) => emit(ProfileError(failure.errMessage)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> saveProfile({
    required String uid,
    required String fullName,
    required String bio,
  }) async {
    emit(ProfileSaving());
    final result = await profileRepo.updateProfile(
      uid: uid,
      fullName: fullName,
      bio: bio,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.errMessage)),
      (_) => emit(ProfileSaved()),
    );
  }
}
