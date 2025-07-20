import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/content.dart';

abstract class ContentRepository {
  Future<Either<Failure, List<Content>>> getContents();
  Future<Either<Failure, Content>> getContentById(String id);
  Future<Either<Failure, List<Content>>> getContentsByUserId(String userId);
  Future<Either<Failure, Content>> createContent(Content content);
  Future<Either<Failure, Content>> updateContent(Content content);
  Future<Either<Failure, void>> deleteContent(String id);
}