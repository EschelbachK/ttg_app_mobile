import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(dioProvider));
});

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) {
    return dio.post(path, data: data);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) {
    return dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return dio.delete(path);
  }
}