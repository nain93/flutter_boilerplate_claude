import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Manual dependency registration for now
  // This will be replaced with generated code later
}

Future<void> initializeDependencies() async {
  // Core
  // Features - Counter
  // TODO: Add automatic dependency injection with build_runner
}