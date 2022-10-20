import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/github/core/domain/github_failure.dart';
import 'package:repo_viewer/github/repos/core/presentation/paginated_repos_list_view.dart';

class FailureReposTile extends ConsumerWidget {
  final GithubFailure failure;
  const FailureReposTile({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTileTheme(
      textColor: Theme.of(context).colorScheme.onError,
      iconColor: Theme.of(context).colorScheme.onError,
      child: Card(
        color: Theme.of(context).errorColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          title: Text('An error occurred, please, retry'),
          subtitle: Text(
            failure.map(api: (_) => "API returned ${_.errorCode}"),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading:
              SizedBox(height: double.infinity, child: Icon(Icons.warning)),
          trailing: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // ref
              //     .read(starredReposNotifierProvider.notifier)
              //     .getNextStarredReposPage();

              context
                  .findAncestorWidgetOfExactType<PaginatedReposListView>()
                  ?.getNextPage(ref);
            },
          ),
        ),
      ),
    );
  }
}
