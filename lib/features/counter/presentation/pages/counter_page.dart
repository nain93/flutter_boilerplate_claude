import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/manual_injection.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CounterBloc>()..add(const CounterEvent.started()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Counter'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              _CounterDisplay(),
            ],
          ),
        ),
        floatingActionButton: const _CounterFAB(),
      ),
    );
  }
}

class _CounterDisplay extends StatelessWidget {
  const _CounterDisplay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Text('0'),
          loading: () => const CircularProgressIndicator(),
          loaded: (value) => Text(
            '$value',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          error: (message) => Text(
            'Error: $message',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}

class _CounterFAB extends StatelessWidget {
  const _CounterFAB();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<CounterBloc>().add(const CounterEvent.incremented());
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}