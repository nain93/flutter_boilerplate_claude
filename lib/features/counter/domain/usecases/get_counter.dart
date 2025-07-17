import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

@injectable
class GetCounter implements UseCaseNoParams<Counter> {
  final CounterRepository repository;
  
  GetCounter(this.repository);
  
  @override
  Future<Either<Failure, Counter>> call() async {
    return await repository.getCounter();
  }
}