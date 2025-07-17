import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/get_user_by_id.dart';
import 'users_event.dart';
import 'users_state.dart';

@injectable
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;
  final GetUserById getUserById;
  
  UsersBloc({
    required this.getUsers,
    required this.getUserById,
  }) : super(const UsersState.initial()) {
    on<GetUsersEvent>(_onGetUsers);
    on<GetUserByIdEvent>(_onGetUserById);
  }
  
  Future<void> _onGetUsers(
    GetUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UsersState.loading());
    
    final result = await getUsers();
    result.fold(
      (failure) => emit(UsersState.error(failure.when(
        server: (message) => message,
        cache: (message) => message,
        network: (message) => message,
        validation: (message) => message,
      ))),
      (users) => emit(UsersState.loaded(users)),
    );
  }
  
  Future<void> _onGetUserById(
    GetUserByIdEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UsersState.loading());
    
    final result = await getUserById(event.userId);
    result.fold(
      (failure) => emit(UsersState.error(failure.when(
        server: (message) => message,
        cache: (message) => message,
        network: (message) => message,
        validation: (message) => message,
      ))),
      (user) => emit(UsersState.userLoaded(user)),
    );
  }
}