class ApiConfig {
  const ApiConfig._();

  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:8080';
  static const String localBaseUrl = 'http://localhost:8080';
  static const String loopbackBaseUrl = 'http://127.0.0.1:8080';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: loopbackBaseUrl,
  );
}
