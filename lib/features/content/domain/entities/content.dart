import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.freezed.dart';

@freezed
class Content with _$Content {
  const factory Content({
    required String id,
    required String title,
    required String body,
    String? excerpt,
    String? authorId,
    String? status,
    String? type,
    @Default([]) List<String> tags,
    String? featuredImageUrl,
    String? slug,
    @Default(0) int viewCount,
    @Default(0) int likeCount,
    String? publishedAt,
    String? createdAt,
    String? updatedAt,
  }) = _Content;
}