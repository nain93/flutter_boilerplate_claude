import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_datasource.dart';
import '../models/counter_model.dart';

@Injectable(as: CounterRepository)
class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;
  
  CounterRepositoryImpl(this.localDataSource);
  
  @override
  Future<Either<Failure, Counter>> getCounter() async {
    try {
      final localCounter = await localDataSource.getLastCounter();
      return Right(localCounter.toEntity());
    } catch (e) {
      return const Left(Failure.cache('Failed to get counter from cache'));
    }
  }
  
  @override
  Future<Either<Failure, Counter>> incrementCounter() async {
    try {
      final currentCounter = await localDataSource.getLastCounter();
      final newCounter = CounterModel(value: currentCounter.value + 1);
      await localDataSource.cacheCounter(newCounter);
      return Right(newCounter.toEntity());
    } catch (e) {
      return const Left(Failure.cache('Failed to increment counter'));
    }
  }
  
  @override
  Future<Either<Failure, Counter>> decrementCounter() async {
    try {
      final currentCounter = await localDataSource.getLastCounter();
      final newCounter = CounterModel(value: currentCounter.value - 1);
      await localDataSource.cacheCounter(newCounter);
      return Right(newCounter.toEntity());
    } catch (e) {
      return const Left(Failure.cache('Failed to decrement counter'));
    }
  }
}