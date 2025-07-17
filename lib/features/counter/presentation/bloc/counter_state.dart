import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_state.freezed.dart';

@freezed
class CounterState with _$CounterState {
  const factory CounterState.initial() = CounterInitial;
  const factory CounterState.loading() = CounterLoading;
  const factory CounterState.loaded(int value) = CounterLoaded;
  const factory CounterState.error(String message) = CounterError;
}