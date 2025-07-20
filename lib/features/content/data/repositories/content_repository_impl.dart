import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate_claude/features/content/data/models/content_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/content_remote_datasource.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ContentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Content>>> getContents() async {
    if (await networkInfo.isConnected) {
      try {
        final contentModels = await remoteDataSource.getContents();
        final contents = contentModels
            .map((model) => model.toEntity())
            .toList();
        return Right(contents);
      } catch (e) {
        return Left(Failure.server(e.toString()));
      }
    } else {
      return Left(Failure.network('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Content>> getContentById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final contentModel = await remoteDataSource.getContentById(id);
        return Right(contentModel.toEntity());
      } catch (e) {
        return Left(Failure.server(e.toString()));
      }
    } else {
      return Left(Failure.network('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getContentsByUserId(
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final contentModels = await remoteDataSource.getContentsByUserId(
          userId,
        );
        final contents = contentModels
            .map((model) => model.toEntity())
            .toList();
        return Right(contents);
      } catch (e) {
        return Left(Failure.server(e.toString()));
      }
    } else {
      return Left(Failure.network('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Content>> createContent(Content content) async {
    if (await networkInfo.isConnected) {
      try {
        final contentModel = await remoteDataSource.createContent(
          ContentModel.fromEntity(content),
        );
        return Right(contentModel.toEntity());
      } catch (e) {
        return Left(Failure.server(e.toString()));
      }
    } else {
      return Left(Failure.network('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Content>> updateContent(Content content) async {
    if (await networkInfo.isConnected) {
      try {
        final contentModel = await remoteDataSource.updateContent(
          ContentModel.fromEntity(content),
        );
        return Right(contentModel.toEntity());
      } catch (e) {
        return Left(Failure.server(e.toString()));
      }
    } else {
      return Left(Failure.network('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContent(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteContent(id);
        return const Right(null);
      } catch (e) {
        return Left(Failure.server(e.toString()));
      }
    } else {
      return Left(Failure.network('No internet connection'));
    }
  }
}
