// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GithubRepoDTO _$$_GithubRepoDTOFromJson(Map<String, dynamic> json) =>
    _$_GithubRepoDTO(
      description: _descriptionFromJson(json['description']),
      name: json['name'] as String,
      stargazersCount: json['stargazers_count'] as int,
      owner: UserDTO.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_GithubRepoDTOToJson(_$_GithubRepoDTO instance) =>
    <String, dynamic>{
      'description': instance.description,
      'name': instance.name,
      'stargazers_count': instance.stargazersCount,
      'owner': instance.owner.toJson(),
    };
