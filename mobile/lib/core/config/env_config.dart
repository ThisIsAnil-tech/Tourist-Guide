class EnvConfig {
  EnvConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static const meshGatewayApiKey = String.fromEnvironment(
    'MESH_GATEWAY_API_KEY',
    defaultValue: '',
  );

  static const environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isProduction => environment == 'production';
}