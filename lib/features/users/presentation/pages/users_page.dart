import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/manual_injection.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';
import '../widgets/user_list_item.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UsersBloc>()..add(const UsersEvent.getUsers()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Users'),
        ),
        body: const _UsersBody(),
      ),
    );
  }
}

class _UsersBody extends StatelessWidget {
  const _UsersBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: Text('No users available')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (users) => RefreshIndicator(
            onRefresh: () async {
              context.read<UsersBloc>().add(const UsersEvent.getUsers());
            },
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserListItem(user: user);
              },
            ),
          ),
          userLoaded: (user) => Center(
            child: UserListItem(user: user),
          ),
          error: (message) => AppErrorWidget(
            title: 'Failed to load users',
            message: message,
            onRetry: () {
              context.read<UsersBloc>().add(const UsersEvent.getUsers());
            },
          ),
        );
      },
    );
  }
}