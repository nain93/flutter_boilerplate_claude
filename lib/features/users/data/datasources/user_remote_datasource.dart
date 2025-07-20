import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String id);
}

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;
  
  UserRemoteDataSourceImpl(this.supabaseClient);
  
  @override
  Future<List<UserModel>> getUsers() async {
    final response = await supabaseClient
        .from('users')
        .select();
    
    return (response as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }
  
  @override
  Future<UserModel> getUserById(String id) async {
    final response = await supabaseClient
        .from('users')
        .select()
        .eq('id', id)
        .single();
    
    return UserModel.fromJson(response);
  }
}