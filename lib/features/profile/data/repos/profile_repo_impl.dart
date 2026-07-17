// features/profile/data/repos/profile_repo_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_verse_app/core/errors/failures.dart';
import 'package:movie_verse_app/features/profile/data/models/user_profile_model.dart';
import 'package:movie_verse_app/features/profile/data/repos/profile_repo.dart';

class ProfileRepoImpl extends ProfileRepo {
  final FirebaseFirestore _firestore;

  ProfileRepoImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserProfileModel>> getProfile({
    required String uid,
  }) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        return Left(ServerFailure('Profile not found.'));
      }
      return Right(UserProfileModel.fromJson(uid, doc.data()!));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile({
    required String uid,
    required String fullName,
    required String bio,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'fullName': fullName,
        'bio': bio,
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
