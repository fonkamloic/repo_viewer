import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_viewer/github/detail/infrastructure/repo_detail_local_service.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/timestamp.dart';

import '../domain/github_repo_detail.dart';
part 'github_repo_detail_dto.freezed.dart';
part 'github_repo_detail_dto.g.dart';

@freezed
class GithubRepoDetailDTO with _$GithubRepoDetailDTO {
  const GithubRepoDetailDTO._();
  const factory GithubRepoDetailDTO({
    required String html,
    required String fullName,
    required bool starred,
  }) = _GithubRepoDetailDTO;

  factory GithubRepoDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$GithubRepoDetailDTOFromJson(json);
  factory GithubRepoDetailDTO.fromDomain(GithubRepoDetail _) {
    return GithubRepoDetailDTO(
      html: _.html,
      fullName: _.fullName,
      starred: _.starred,
    );
  }
  GithubRepoDetail toDomain() {
    return GithubRepoDetail(
      html: html,
      fullName: fullName,
      starred: starred,
    );
  }

  Map<String, dynamic> toSembast() {
    final json = toJson();
    json.remove('fullName');
    json[RepoDetailLocalService.lastUsedFieldName] = Timestamp.now();
    return json;
  }

  factory GithubRepoDetailDTO.fromSembast(
      RecordSnapshot<String, Map<String, dynamic>> snapshot) {
    final copiedMap = Map<String, dynamic>.from(snapshot.value);
    copiedMap['fullName'] = snapshot.key;
    return GithubRepoDetailDTO.fromJson(snapshot.value);
  }
}
