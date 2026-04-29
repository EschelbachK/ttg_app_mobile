import 'dart:io';
import 'package:dio/dio.dart';

class MediaService {
  final Dio dio;
  MediaService(this.dio);

  Future<String?> uploadMedia({required String exerciseId, required String filePath}) async {
    final file = File(filePath);
    if (!file.existsSync()) return null;

    final formData = FormData.fromMap({
      'exerciseId': exerciseId,
      'file': await MultipartFile.fromFile(filePath, filename: file.uri.pathSegments.last),
    });

    try {
      final res = await dio.post('/api/catalog/exercises/media', data: formData);
      if (res.statusCode == 200 && res.data != null) return res.data['url'] as String?;
    } catch (_) {}
    return null;
  }

  Future<String> getMediaPlaceholder() async => 'assets/images/placeholder.png';
}