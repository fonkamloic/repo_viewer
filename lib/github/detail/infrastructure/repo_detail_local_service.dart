import 'package:repo_viewer/core/infrastructure/sembast_database.dart';
import 'package:repo_viewer/github/core/infrastructure/github_headers_cache.dart';
import 'package:repo_viewer/github/detail/infrastructure/github_repo_detail_dto.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

class RepoDetailLocalService {
  final SembastDatabase _sembastDatabase;
  final GithubHeadersCache _headersCache;
  final _store = stringMapStoreFactory.store('repoDetails');

  RepoDetailLocalService(this._sembastDatabase, this._headersCache);

  static const cacheSize = 50;
  static const lastUsedFieldName = 'lastUsed';

  Future<void> upsertRepoDetail(GithubRepoDetailDTO githubRepoDetailDTO) async {
    await _store.record(githubRepoDetailDTO.fullName).put(
          _sembastDatabase.instance,
          githubRepoDetailDTO.toSembast(),
        );

    final keys = await _store.findKeys(_sembastDatabase.instance,
        finder: Finder(sortOrders: [
          SortOrder(lastUsedFieldName, false),
        ]));

    if (keys.length > cacheSize) {
      final keysToRemove = keys.sublist(cacheSize);
      for (final key in keysToRemove) {
        final requestUri =
            Uri.https('api.github.com', '/repos/$key/readme');
        await _store.record(key).delete(_sembastDatabase.instance);
        await _headersCache.deleteHeaders(requestUri);
      }
    }
  }

  Future<GithubRepoDetailDTO?> getRepoDetail(String fullRepoName) async {
    final record = _store.record(fullRepoName);

    record.update(
        _sembastDatabase.instance, {lastUsedFieldName: Timestamp.now()});

    final recordSnapshot = await record.getSnapshot(_sembastDatabase.instance);
    if (recordSnapshot == null) {
      return null;
    }
    return GithubRepoDetailDTO.fromSembast(recordSnapshot);
  }
}
