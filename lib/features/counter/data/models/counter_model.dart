import '../../domain/entities/counter.dart';

class CounterModel {
  final int value;
  
  const CounterModel({required this.value});
  
  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(value: json['value'] as int);
  }
  
  Map<String, dynamic> toJson() {
    return {'value': value};
  }
  
  factory CounterModel.fromEntity(Counter counter) {
    return CounterModel(value: counter.value);
  }
  
  Counter toEntity() {
    return Counter(value: value);
  }
}