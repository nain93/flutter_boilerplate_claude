// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_boilerplate_claude/core/network/dio_client.dart'
    as _i41;
import 'package:flutter_boilerplate_claude/core/network/network_info.dart'
    as _i381;
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
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

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
    gh.factory<_i269.UserRemoteDataSource>(
        () => _i269.UserRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
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
