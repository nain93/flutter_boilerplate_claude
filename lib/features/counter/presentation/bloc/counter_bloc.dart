import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_counter.dart';
import '../../domain/usecases/increment_counter.dart';
import 'counter_event.dart';
import 'counter_state.dart';

@injectable
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final GetCounter getCounter;
  final IncrementCounter incrementCounter;
  
  CounterBloc({
    required this.getCounter,
    required this.incrementCounter,
  }) : super(const CounterState.initial()) {
    on<CounterStarted>(_onCounterStarted);
    on<CounterIncremented>(_onCounterIncremented);
  }
  
  Future<void> _onCounterStarted(
    CounterStarted event,
    Emitter<CounterState> emit,
  ) async {
    emit(const CounterState.loading());
    
    final result = await getCounter();
    result.fold(
      (failure) => emit(CounterState.error(failure.when(
        server: (message) => message,
        cache: (message) => message,
        network: (message) => message,
        validation: (message) => message,
      ))),
      (counter) => emit(CounterState.loaded(counter.value)),
    );
  }
  
  Future<void> _onCounterIncremented(
    CounterIncremented event,
    Emitter<CounterState> emit,
  ) async {
    final result = await incrementCounter();
    result.fold(
      (failure) => emit(CounterState.error(failure.when(
        server: (message) => message,
        cache: (message) => message,
        network: (message) => message,
        validation: (message) => message,
      ))),
      (counter) => emit(CounterState.loaded(counter.value)),
    );
  }
}