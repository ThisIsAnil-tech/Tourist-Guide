import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';
import '../secure_storage_service.dart';

class ApiClient {
  static final ApiClient instance = ApiClient._internal();

  late final Dio dio;
  final _storage = SecureStorageService.instance;

  ApiClient._internal() {
    dio = Dio(BaseOptions(baseUrl: EnvConfig.apiBaseUrl));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          final refreshed = await _tryRefresh();
          if (refreshed) {
            final retryResponse = await _retry(error.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
        handler.next(error);
      },
    ));
  }

  bool _isRefreshing = false;

  Future<bool> _tryRefresh() async {
    _isRefreshing = true;
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio(BaseOptions(baseUrl: EnvConfig.apiBaseUrl)).post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      await _storage.saveTokens(
        response.data['access_token'] as String,
        refreshToken,
      );
      return true;
    } catch (_) {
      await _storage.clearTokens();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await _storage.getAccessToken();
    final options = Options(method: requestOptions.method, headers: {
      ...requestOptions.headers,
      'Authorization': 'Bearer $token',
    });
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}