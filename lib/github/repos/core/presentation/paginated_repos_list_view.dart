import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:repo_viewer/core/presentation/toasts.dart';
import 'package:repo_viewer/github/core/presentation/no_results_display.dart';
import 'package:repo_viewer/github/repos/core/application/paginated_repos_notifier.dart';
import 'package:repo_viewer/github/repos/core/presentation/failure_repos_tile.dart';
import 'package:repo_viewer/github/repos/core/presentation/loading_repo_tile.dart';
import 'package:repo_viewer/github/repos/core/presentation/repo_tile.dart';

class PaginatedReposListView extends ConsumerStatefulWidget {
  final AutoDisposeStateNotifierProvider<PaginatedReposNotifier,
      PaginatedReposState> paginatedReposNotifierProvider;
  const PaginatedReposListView({
    required this.paginatedReposNotifierProvider,
    required this.getNextPage,
    required this.noResultMessage,
    Key? key,
  }) : super(key: key);
  final void Function(WidgetRef ref) getNextPage;
  final String noResultMessage;

  @override
  ConsumerState<PaginatedReposListView> createState() =>
      _PaginatedReposListViewState();
}

class _PaginatedReposListViewState
    extends ConsumerState<PaginatedReposListView> {
  bool canLoadNextPage = false;
  bool hasAlreadyShownNoConnectionToast = false;
  @override
  Widget build(BuildContext context) {
    ref.listen<PaginatedReposState>(widget.paginatedReposNotifierProvider,
        (previous, next) {
      next.map(
        initial: (_) => canLoadNextPage = true,
        loadInProgress: (_) => canLoadNextPage = false,
        loadSuccess: (_) {
          if (!_.repos.isFresh && !hasAlreadyShownNoConnectionToast) {
            hasAlreadyShownNoConnectionToast = true;
            showNoConnectionToast(
                "You're not online. Some information may be outdated.",
                context);
          }
          return canLoadNextPage = _.isNextPageAvailable;
        },
        loadFailure: (_) => canLoadNextPage = false,
      );
    });
    final state = ref.watch(widget.paginatedReposNotifierProvider);
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          final limit = metrics.maxScrollExtent - metrics.viewportDimension / 3;

          if (canLoadNextPage && metrics.pixels >= limit) {
            canLoadNextPage = false;
            widget.getNextPage(ref);
          }
          return false;
        },
        child: state.maybeWhen(
          loadSuccess: (repos, _) => repos.entity.isEmpty,
          orElse: () => false,
        )
            ? NoResultDisplay(message: widget.noResultMessage)
            : _PaginatedListView(state: state));
  }
}

class _PaginatedListView extends StatelessWidget {
  const _PaginatedListView({
    Key? key,
    required this.state,
  }) : super(key: key);

  final PaginatedReposState state;

  @override
  Widget build(BuildContext context) {
    // context.findAncestorStateOfType<FloatingSearchBarState>()?.widget.height;
    final fsb = FloatingSearchBar.of(context)?.widget;
    return ListView.builder(
      padding: fsb == null
          ? EdgeInsets.zero
          : EdgeInsets.only(
              top: fsb.height + 8 + MediaQuery.of(context).padding.top),
      itemCount: state.map(
          initial: (_) => 0,
          loadInProgress: (_) => _.repos.entity.length + _.itemsPerPage,
          loadSuccess: (_) => _.repos.entity.length,
          loadFailure: (_) => _.repos.entity.length + 1),
      itemBuilder: (context, index) => state.map(
        initial: (fresh) => RepoTile(repo: fresh.repos.entity[index]),
        loadInProgress: (fresh) {
          if (index < fresh.repos.entity.length) {
            return RepoTile(
              repo: fresh.repos.entity[index],
            );
          } else
            return LoadingRepoTile();
        },
        loadSuccess: (fresh) => RepoTile(
          repo: fresh.repos.entity[index],
        ),
        loadFailure: (fresh) {
          if (index < fresh.repos.entity.length) {
            return RepoTile(repo: fresh.repos.entity[index]);
          } else
            return FailureReposTile(failure: fresh.failure);
        },
      ),
    );
  }
}
