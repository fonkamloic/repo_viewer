import 'package:dio/dio.dart';
import 'package:repo_viewer/core/infrastructure/remote_response.dart';
import 'package:repo_viewer/github/core/infrastructure/github_headers_cache.dart';
import 'package:repo_viewer/github/core/infrastructure/github_repo_dto.dart';
import 'package:repo_viewer/github/core/infrastructure/pagination_config.dart';
import 'package:repo_viewer/github/repos/core/infrastructure/repos_remote_service.dart';

class SearchedReposRemoteService extends ReposRemoteService {
  SearchedReposRemoteService(Dio dio, GithubHeadersCache headersCache)
      : super(dio, headersCache);

  Future<RemoteResponse<List<GithubRepoDTO>>> getSearchedReposPage(
    String query,
    int page,
  ) async {
    final requestUri = Uri.https('api.github.com', '/search/repositories', {
      'page': '$page',
      'q': '$query',
      'per_page': PaginationConfig.itemPerPage.toString(),
    });

    return super.getPage(
        requestUri: requestUri,
        jsonDataSelector: (json) => json['items'] as List<dynamic>);
  }
}
