import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/content.dart';
import '../repositories/content_repository.dart';

class GetContents implements UseCase<List<Content>, NoParams> {
  final ContentRepository repository;

  GetContents(this.repository);

  @override
  Future<Either<Failure, List<Content>>> call(NoParams params) async {
    return await repository.getContents();
  }
}