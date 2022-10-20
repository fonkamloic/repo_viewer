import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/auth/shared/providers.dart';
import 'package:repo_viewer/core/presentation/routes/app_router.gr.dart';
import 'package:repo_viewer/github/core/shared/providers.dart';
import 'package:repo_viewer/github/repos/core/presentation/paginated_repos_list_view.dart';
import 'package:repo_viewer/search/presentation/search_bar.dart';

class SearchedReposPage extends ConsumerStatefulWidget {
  final String searchTerm;
  const SearchedReposPage({super.key, required this.searchTerm});

  @override
  ConsumerState<SearchedReposPage> createState() => _SearchedReposPageState();
}

class _SearchedReposPageState extends ConsumerState<SearchedReposPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(searchedReposNotifierProvider.notifier)
        .getNextSearchedReposPage(widget.searchTerm));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SearchBar(
      hint: widget.searchTerm,
      title: 'Starred repositories',
      onShouldNavigateToResultPage: (searchTerm) {
        context.router.pushAndPopUntil(
          SearchedReposRoute(searchTerm: searchTerm),
          predicate: (route) => route.settings.name == StarredReposRoute.name,
        );
      },
      onSignOutButtonPressed: () {
        ref.read(authNotifierProvider.notifier).signOut();
      },
      body: PaginatedReposListView(
        paginatedReposNotifierProvider: searchedReposNotifierProvider,
        getNextPage: (ref) {
          ref
              .read(searchedReposNotifierProvider.notifier)
              .getNextSearchedReposPage(widget.searchTerm);
        },
        noResultMessage:
            "That's about everything we could find for your search term",
      ),
    ));
  }
}
