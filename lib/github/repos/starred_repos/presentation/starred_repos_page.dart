import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/auth/shared/providers.dart';
import 'package:repo_viewer/core/presentation/routes/app_router.gr.dart';
import 'package:repo_viewer/github/core/shared/providers.dart';
import 'package:repo_viewer/github/repos/core/presentation/paginated_repos_list_view.dart';
import 'package:repo_viewer/search/presentation/search_bar.dart';

class StarredReposPage extends ConsumerStatefulWidget {
  const StarredReposPage({super.key});

  @override
  ConsumerState<StarredReposPage> createState() => _StarredReposPageState();
}

class _StarredReposPageState extends ConsumerState<StarredReposPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() async => await );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(starredReposNotifierProvider.notifier).getNextStarredReposPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SearchBar(
      hint: 'Search all repositories...',
      title: 'Starred repositories',
      onShouldNavigateToResultPage: (searchTerm) {
        context.router.push(SearchedReposRoute(searchTerm: searchTerm));
      },
      onSignOutButtonPressed: () {
        ref.read(authNotifierProvider.notifier).signOut();
      },
      body: PaginatedReposListView(
        paginatedReposNotifierProvider: starredReposNotifierProvider,
        getNextPage: (ref) {
          ref
              .read(starredReposNotifierProvider.notifier)
              .getNextStarredReposPage();
        },
        noResultMessage:
            "That's about everything we could find in your starred repos right now",
      ),
    ));
  }
}
