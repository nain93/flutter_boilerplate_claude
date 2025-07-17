import 'package:injectable/injectable.dart';
import '../models/counter_model.dart';

abstract class CounterLocalDataSource {
  Future<CounterModel> getLastCounter();
  Future<void> cacheCounter(CounterModel counterModel);
}

@Injectable(as: CounterLocalDataSource)
class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  int _cachedValue = 0;
  
  @override
  Future<CounterModel> getLastCounter() async {
    return CounterModel(value: _cachedValue);
  }
  
  @override
  Future<void> cacheCounter(CounterModel counterModel) async {
    _cachedValue = counterModel.value;
  }
}