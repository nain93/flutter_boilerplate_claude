import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'users_state.freezed.dart';

@freezed
class UsersState with _$UsersState {
  const factory UsersState.initial() = UsersInitial;
  const factory UsersState.loading() = UsersLoading;
  const factory UsersState.loaded(List<User> users) = UsersLoaded;
  const factory UsersState.userLoaded(User user) = UserLoaded;
  const factory UsersState.error(String message) = UsersError;
}