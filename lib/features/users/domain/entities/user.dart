import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    String? bio,
    String? location,
    String? website,
    String? createdAt,
    String? updatedAt,
  }) = _User;
}