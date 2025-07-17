import 'package:injectable/injectable.dart';
import '../../../../core/network/api_service.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(int id);
}

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiService apiService;
  
  UserRemoteDataSourceImpl(this.apiService);
  
  @override
  Future<List<UserModel>> getUsers() async {
    return await apiService.getUsers();
  }
  
  @override
  Future<UserModel> getUserById(int id) async {
    return await apiService.getUserById(id);
  }
}