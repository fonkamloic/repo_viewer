import 'package:repo_viewer/github/core/infrastructure/pagination_config.dart';
import 'package:repo_viewer/github/repos/core/application/paginated_repos_notifier.dart';
import 'package:repo_viewer/github/repos/starred_repos/infrastructure/starred_repos_repository.dart';

class StarredReposNotifier extends PaginatedReposNotifier {
  final StarredReposRepository _repository;
  StarredReposNotifier(this._repository);

  Future<void> getFirstStarredReposPage() async {
    super.resetState();
    await getFirstStarredReposPage();
  }

  Future<void> getNextStarredReposPage() async {
    super.getNextPage((page) => _repository.getStarredReposPage(page));
  }
}
