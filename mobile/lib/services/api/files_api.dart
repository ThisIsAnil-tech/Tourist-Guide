import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart';

class FilesApi {
  static final FilesApi instance = FilesApi._internal();
  FilesApi._internal();

  final _dio = ApiClient.instance.dio;

  Future<String> uploadFile({
    required File file,
    required String fileType,
    String? relatedSosEventId,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'file_type': fileType,
      if (relatedSosEventId != null) 'related_sos_event_id': relatedSosEventId,
    });

    final response = await _dio.post('/files/upload', data: formData);
    return response.data['url'] as String;
  }
}