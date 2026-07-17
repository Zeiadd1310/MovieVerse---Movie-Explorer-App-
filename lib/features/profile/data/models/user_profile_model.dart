class UserProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String bio;
  final String? photoUrl;
  final int followersCount;
  final int followingCount;

  UserProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.followersCount,
    required this.followingCount,
  });

  factory UserProfileModel.fromJson(String uid, Map<String, dynamic> json) {
    return UserProfileModel(
      uid: uid,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      photoUrl: json['photoUrl'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }
}
