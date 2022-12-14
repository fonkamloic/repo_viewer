import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/core/infrastructure/sembast_database.dart';
import 'package:repo_viewer/core/presentation/routes/app_router.gr.dart';

final sembastProvider = Provider((ref) => SembastDatabase());
final dioProvider = Provider((ref) => Dio());

final appRouterProvider = Provider((ref) => AppRouter());
