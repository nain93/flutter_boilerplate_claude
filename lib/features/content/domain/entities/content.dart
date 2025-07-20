import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.freezed.dart';

@freezed
class Content with _$Content {
  const factory Content({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String authorId,
    required String authorName,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int likes,
    required int views,
    @Default([]) List<String> tags,
  }) = _Content;
}