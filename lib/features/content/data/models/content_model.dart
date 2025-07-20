import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/content.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

@freezed
class ContentModel with _$ContentModel {
  const factory ContentModel({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String authorId,
    required String authorName,
    required String createdAt,
    required String updatedAt,
    required int likes,
    required int views,
    @Default([]) List<String> tags,
  }) = _ContentModel;

  const ContentModel._();

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);

  Content toEntity() {
    return Content(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      authorId: authorId,
      authorName: authorName,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      likes: likes,
      views: views,
      tags: tags,
    );
  }

  factory ContentModel.fromEntity(Content content) {
    return ContentModel(
      id: content.id,
      title: content.title,
      description: content.description,
      imageUrl: content.imageUrl,
      authorId: content.authorId,
      authorName: content.authorName,
      createdAt: content.createdAt.toIso8601String(),
      updatedAt: content.updatedAt.toIso8601String(),
      likes: content.likes,
      views: content.views,
      tags: content.tags,
    );
  }
}
