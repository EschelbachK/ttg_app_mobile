import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/application/settings_provider.dart';
import 'dio_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref, ref.read(dioProvider));
});

class ApiClient {
  final Ref ref;
  final Dio dio;

  ApiClient(this.ref, this.dio);

  bool get _offline => ref.read(settingsProvider).offlineMode;

  Future<Response> _run(Future<Response> Function() req) async {
    if (_offline) {
      throw Exception('Offline mode active');
    }
    return await req();
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) =>
      _run(() => dio.get(path, queryParameters: query));

  Future<Response> post(String path, {Map<String, dynamic>? data}) =>
      _run(() => dio.post(path, data: data));

  Future<Response> put(String path, {Map<String, dynamic>? data}) =>
      _run(() => dio.put(path, data: data));

  Future<Response> delete(String path) =>
      _run(() => dio.delete(path));
}