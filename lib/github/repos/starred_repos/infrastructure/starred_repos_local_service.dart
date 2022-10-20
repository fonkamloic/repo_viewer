import 'package:repo_viewer/core/infrastructure/sembast_database.dart';
import 'package:repo_viewer/github/core/infrastructure/github_repo_dto.dart';
import 'package:repo_viewer/github/core/infrastructure/pagination_config.dart';
import 'package:sembast/sembast.dart';
import 'package:collection/collection.dart';

class StarredReposLocalService {
  final SembastDatabase _sembastDatabase;

  final _store = intMapStoreFactory.store('starredRepos');

  StarredReposLocalService(this._sembastDatabase);

  Future<void> upsertPage(List<GithubRepoDTO> dtos, int page) async {
    final sembastPage = page--;
    await _store
        .records(dtos.mapIndexed(
          (index, element) =>
              index + PaginationConfig.itemPerPage * sembastPage,
        ))
        .put(_sembastDatabase.instance, dtos.map((e) => e.toJson()).toList());
  }

  Future<List<GithubRepoDTO>> getPage(int page) async {
    final sembastPage = page - 1;
    final records = await _store.find(
      _sembastDatabase.instance,
      finder: Finder(
        limit: PaginationConfig.itemPerPage,
        offset: PaginationConfig.itemPerPage * sembastPage,
      ),
    );
    return records.map((e) => GithubRepoDTO.fromJson(e.value)).toList();
  }

  Future<int> getLocalPageCount() async {
    final repoCount = await _store.count(_sembastDatabase.instance);
    return (repoCount / PaginationConfig.itemPerPage).ceil();
  }
}
