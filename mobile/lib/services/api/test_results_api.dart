import '../../models/test_result_model.dart';
import 'api_client.dart';

class TestResultsApi {
  static final TestResultsApi instance = TestResultsApi._internal();
  TestResultsApi._internal();

  final _dio = ApiClient.instance.dio;

  Future<void> submitResult(TestResultModel result) async {
    await _dio.post('/test-results', data: result.toJson());
  }
}