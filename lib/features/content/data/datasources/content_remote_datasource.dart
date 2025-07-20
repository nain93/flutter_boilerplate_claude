import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/content_model.dart';

abstract class ContentRemoteDataSource {
  Future<List<ContentModel>> getContents();
  Future<ContentModel> getContentById(String id);
  Future<List<ContentModel>> getContentsByUserId(String userId);
  Future<ContentModel> createContent(ContentModel content);
  Future<ContentModel> updateContent(ContentModel content);
  Future<void> deleteContent(String id);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final SupabaseClient supabaseClient;
  static const String tableName = 'contents';

  ContentRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ContentModel>> getContents() async {
    try {
      final response = await supabaseClient
          .from(tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => ContentModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch contents: $e');
    }
  }

  @override
  Future<ContentModel> getContentById(String id) async {
    try {
      final response = await supabaseClient
          .from(tableName)
          .select()
          .eq('id', id)
          .single();

      return ContentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch content: $e');
    }
  }

  @override
  Future<List<ContentModel>> getContentsByUserId(String userId) async {
    try {
      final response = await supabaseClient
          .from(tableName)
          .select()
          .eq('author_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => ContentModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user contents: $e');
    }
  }

  @override
  Future<ContentModel> createContent(ContentModel content) async {
    try {
      final response = await supabaseClient
          .from(tableName)
          .insert(content.toJson())
          .select()
          .single();

      return ContentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create content: $e');
    }
  }

  @override
  Future<ContentModel> updateContent(ContentModel content) async {
    try {
      final response = await supabaseClient
          .from(tableName)
          .update(content.toJson())
          .eq('id', content.id)
          .select()
          .single();

      return ContentModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update content: $e');
    }
  }

  @override
  Future<void> deleteContent(String id) async {
    try {
      await supabaseClient.from(tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete content: $e');
    }
  }
}
