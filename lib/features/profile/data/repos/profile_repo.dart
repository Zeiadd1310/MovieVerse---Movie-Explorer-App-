import 'package:dartz/dartz.dart';
import 'package:movie_verse_app/core/errors/failures.dart';
import 'package:movie_verse_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserProfileModel>> getProfile({required String uid});

  Future<Either<Failure, Unit>> updateProfile({
    required String uid,
    required String fullName,
    required String bio,
  });
}
