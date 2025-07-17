import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@injectable
class GetUserById implements UseCase<User, int> {
  final UserRepository repository;
  
  GetUserById(this.repository);
  
  @override
  Future<Either<Failure, User>> call(int id) async {
    return await repository.getUserById(id);
  }
}