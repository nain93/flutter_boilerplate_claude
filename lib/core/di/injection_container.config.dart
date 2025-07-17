// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_boilerplate_claude/core/network/api_service.dart'
    as _i312;
import 'package:flutter_boilerplate_claude/core/network/dio_client.dart'
    as _i41;
import 'package:flutter_boilerplate_claude/core/network/network_info.dart'
    as _i381;
import 'package:flutter_boilerplate_claude/features/counter/data/datasources/counter_local_datasource.dart'
    as _i296;
import 'package:flutter_boilerplate_claude/features/counter/data/repositories/counter_repository_impl.dart'
    as _i730;
import 'package:flutter_boilerplate_claude/features/counter/domain/repositories/counter_repository.dart'
    as _i224;
import 'package:flutter_boilerplate_claude/features/counter/domain/usecases/get_counter.dart'
    as _i236;
import 'package:flutter_boilerplate_claude/features/counter/domain/usecases/increment_counter.dart'
    as _i714;
import 'package:flutter_boilerplate_claude/features/counter/presentation/bloc/counter_bloc.dart'
    as _i688;
import 'package:flutter_boilerplate_claude/features/users/data/datasources/user_remote_datasource.dart'
    as _i269;
import 'package:flutter_boilerplate_claude/features/users/data/repositories/user_repository_impl.dart'
    as _i202;
import 'package:flutter_boilerplate_claude/features/users/domain/repositories/user_repository.dart'
    as _i531;
import 'package:flutter_boilerplate_claude/features/users/domain/usecases/get_user_by_id.dart'
    as _i758;
import 'package:flutter_boilerplate_claude/features/users/domain/usecases/get_users.dart'
    as _i662;
import 'package:flutter_boilerplate_claude/features/users/presentation/bloc/users_bloc.dart'
    as _i597;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i41.DioClient>(() => _i41.DioClient());
    gh.factory<_i296.CounterLocalDataSource>(
        () => _i296.CounterLocalDataSourceImpl());
    gh.factory<_i312.ApiService>(() => _i312.ApiService(gh<_i361.Dio>()));
    gh.factory<_i224.CounterRepository>(
        () => _i730.CounterRepositoryImpl(gh<_i296.CounterLocalDataSource>()));
    gh.factory<_i714.IncrementCounter>(
        () => _i714.IncrementCounter(gh<_i224.CounterRepository>()));
    gh.factory<_i236.GetCounter>(
        () => _i236.GetCounter(gh<_i224.CounterRepository>()));
    gh.factory<_i688.CounterBloc>(() => _i688.CounterBloc(
          getCounter: gh<_i236.GetCounter>(),
          incrementCounter: gh<_i714.IncrementCounter>(),
        ));
    gh.factory<_i269.UserRemoteDataSource>(
        () => _i269.UserRemoteDataSourceImpl(gh<_i312.ApiService>()));
    gh.factory<_i531.UserRepository>(() => _i202.UserRepositoryImpl(
          remoteDataSource: gh<_i269.UserRemoteDataSource>(),
          networkInfo: gh<_i381.NetworkInfo>(),
        ));
    gh.factory<_i662.GetUsers>(
        () => _i662.GetUsers(gh<_i531.UserRepository>()));
    gh.factory<_i758.GetUserById>(
        () => _i758.GetUserById(gh<_i531.UserRepository>()));
    gh.factory<_i597.UsersBloc>(() => _i597.UsersBloc(
          getUsers: gh<_i662.GetUsers>(),
          getUserById: gh<_i758.GetUserById>(),
        ));
    return this;
  }
}
