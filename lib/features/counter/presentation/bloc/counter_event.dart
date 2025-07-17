import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_event.freezed.dart';

@freezed
class CounterEvent with _$CounterEvent {
  const factory CounterEvent.started() = CounterStarted;
  const factory CounterEvent.incremented() = CounterIncremented;
  const factory CounterEvent.decremented() = CounterDecremented;
}