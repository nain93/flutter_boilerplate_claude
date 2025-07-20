import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/content.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

@freezed
class ContentModel with _$ContentModel {
  const factory ContentModel({
    required String id,
    required String title,
    required String body,
    String? excerpt,
    @JsonKey(name: 'author_id') String? authorId,
    String? status,
    String? type,
    @Default([]) List<String> tags,
    @JsonKey(name: 'featured_image_url') String? featuredImageUrl,
    String? slug,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'published_at') String? publishedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _ContentModel;

  const ContentModel._();

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);

  Content toEntity() {
    return Content(
      id: id,
      title: title,
      body: body,
      excerpt: excerpt,
      authorId: authorId,
      status: status,
      type: type,
      tags: tags,
      featuredImageUrl: featuredImageUrl,
      slug: slug,
      viewCount: viewCount,
      likeCount: likeCount,
      publishedAt: publishedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ContentModel.fromEntity(Content content) {
    return ContentModel(
      id: content.id,
      title: content.title,
      body: content.body,
      excerpt: content.excerpt,
      authorId: content.authorId,
      status: content.status,
      type: content.type,
      tags: content.tags,
      featuredImageUrl: content.featuredImageUrl,
      slug: content.slug,
      viewCount: content.viewCount,
      likeCount: content.likeCount,
      publishedAt: content.publishedAt,
      createdAt: content.createdAt,
      updatedAt: content.updatedAt,
    );
  }
}
