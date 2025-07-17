import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../../features/counter/data/datasources/counter_local_datasource.dart';
import '../../features/counter/data/repositories/counter_repository_impl.dart';
import '../../features/counter/domain/repositories/counter_repository.dart';
import '../../features/counter/domain/usecases/get_counter.dart';
import '../../features/counter/domain/usecases/increment_counter.dart';
import '../../features/counter/presentation/bloc/counter_bloc.dart';
import '../../features/users/data/datasources/user_remote_datasource.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/domain/usecases/get_users.dart';
import '../../features/users/domain/usecases/get_user_by_id.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Core
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => ApiService(sl()));

  // Counter feature
  // Data sources
  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCounter(sl()));
  sl.registerLazySingleton(() => IncrementCounter(sl()));

  // BLoC
  sl.registerFactory(
    () => CounterBloc(getCounter: sl(), incrementCounter: sl()),
  );

  // Users feature
  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));

  // BLoC
  sl.registerFactory(() => UsersBloc(getUsers: sl(), getUserById: sl()));
}
