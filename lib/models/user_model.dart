import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final User? user;
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profilePicture;
  final DateTime dateOfBirth;
  final String bio;
  final String gender;
  final bool isSurveyCompleted;

  UserModel({
    required this.user,
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.dateOfBirth,
    required this.bio,
    required this.gender,
    required this.isSurveyCompleted,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, [User? user]) {
    return UserModel(
      user: user,
      id: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      dateOfBirth: data['dateOfBirth'] != null
          ? DateTime.parse(data['dateOfBirth'])
          : DateTime.now(),
      bio: data['bio'] ?? '',
      gender: data['gender'] ?? '',
      isSurveyCompleted: data['isSurveyCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'bio': bio,
      'gender': gender,
      'isSurveyCompleted': isSurveyCompleted,
    };
  }
}
