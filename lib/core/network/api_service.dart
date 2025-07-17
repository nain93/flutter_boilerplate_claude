import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/users/data/models/user_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
@injectable
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @GET("/users")
  Future<List<UserModel>> getUsers();

  @GET("/users/{id}")
  Future<UserModel> getUserById(@Path("id") int id);
}
