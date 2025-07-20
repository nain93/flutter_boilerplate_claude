import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/content.dart';
import '../repositories/content_repository.dart';

class GetContentById implements UseCase<Content, String> {
  final ContentRepository repository;

  GetContentById(this.repository);

  @override
  Future<Either<Failure, Content>> call(String params) async {
    return await repository.getContentById(params);
  }
}