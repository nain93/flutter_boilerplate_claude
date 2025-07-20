import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final userModels = await remoteDataSource.getUsers();
        final users = userModels.map((model) => model.toEntity()).toList();
        return Right(users);
      } catch (e) {
        return Left(Failure.server('Failed to fetch users: ${e.toString()}'));
      }
    } else {
      return const Left(Failure.network('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.getUserById(id);
        return Right(userModel.toEntity());
      } catch (e) {
        return Left(Failure.server('Failed to fetch user: ${e.toString()}'));
      }
    } else {
      return const Left(Failure.network('No internet connection'));
    }
  }
}