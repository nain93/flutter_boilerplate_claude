import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/manual_injection.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/content_bloc.dart';
import '../bloc/content_event.dart';
import '../bloc/content_state.dart';
import '../widgets/content_list_item.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContentBloc>()..add(const ContentEvent.getContents()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contents'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<ContentBloc>().add(
                  const ContentEvent.refreshContents(),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ContentBloc, ContentState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: Text('Welcome to Contents'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              loaded: (contents) {
                if (contents.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No contents available',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Upload your first content to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ContentBloc>().add(
                      const ContentEvent.refreshContents(),
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: contents.length,
                    itemBuilder: (context, index) {
                      return ContentListItem(
                        content: contents[index],
                        onTap: () {
                          // TODO: Navigate to content detail
                        },
                      );
                    },
                  ),
                );
              },
              error: (message) => AppErrorWidget(
                title: 'Failed to load contents',
                message: message,
                onRetry: () {
                  context.read<ContentBloc>().add(
                    const ContentEvent.getContents(),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to create content page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create content feature coming soon!')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}