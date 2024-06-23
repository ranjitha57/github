import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/github_repos_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final githubReposAsyncValue = ref.watch(githubReposProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Repos'),
      ),
      body: githubReposAsyncValue.when(
        data: (repositories) {
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              final repo = repositories[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Theme.of(context).colorScheme.background),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      repo['owner']['avatar_url'],
                    ),
                  ),
                  title: Text(repo['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username: ${repo['owner']['login']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(repo['description'] ?? 'No description available'),
                    ],
                  ),
                  trailing: Text('Stars: ${repo['stargazers_count']}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
