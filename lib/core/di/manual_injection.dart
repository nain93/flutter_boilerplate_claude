import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_boilerplate_claude/features/content/data/datasources/content_remote_datasource.dart';
import 'package:flutter_boilerplate_claude/features/content/domain/usecases/get_content_by_id.dart';
import 'package:flutter_boilerplate_claude/features/content/domain/usecases/get_contents.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_boilerplate_claude/core/config/supabase_config.dart';
import 'package:flutter_boilerplate_claude/core/network/dio_client.dart';
import 'package:flutter_boilerplate_claude/core/network/network_info.dart';
import 'package:flutter_boilerplate_claude/features/content/data/repositories/content_repository_impl.dart';
import 'package:flutter_boilerplate_claude/features/content/domain/repositories/content_repository.dart';
import 'package:flutter_boilerplate_claude/features/content/presentation/bloc/content_bloc.dart';
import 'package:flutter_boilerplate_claude/features/users/data/datasources/user_remote_datasource.dart';
import 'package:flutter_boilerplate_claude/features/users/data/repositories/user_repository_impl.dart';
import 'package:flutter_boilerplate_claude/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_boilerplate_claude/features/users/domain/usecases/get_users.dart';
import 'package:flutter_boilerplate_claude/features/users/domain/usecases/get_user_by_id.dart';
import 'package:flutter_boilerplate_claude/features/users/presentation/bloc/users_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
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

  // Content feature
  // Data sources
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // Repositories
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetContents(sl()));
  sl.registerLazySingleton(() => GetContentById(sl()));

  // BLoC
  sl.registerFactory(
    () => ContentBloc(getContents: sl(), getContentById: sl()),
  );

  // Users feature
  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<SupabaseClient>()),
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
