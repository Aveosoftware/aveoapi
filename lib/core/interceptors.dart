part of 'package:aveo_api/aveo_api.dart';

class AveoApiInterceptors {
  AveoApiInterceptors._instance();
  static AveoApiInterceptors get instance => AveoApiInterceptors._instance();
  factory AveoApiInterceptors(
      {List<Interceptor>? interceptors, BaseOptions? baseOptions}) {
    interceptors = interceptors ?? [];
    baseOptions = baseOptions ??
        BaseOptions(
            connectTimeout: 30000,
            receiveTimeout: 30000,
            validateStatus: (code) {
              if (code! >= 200) {
                return true;
              }
              return false;
            });
    dio = Dio(baseOptions);
    return instance;
  }

  ///To add a list of Interceptor to [Dio] instance. If your [Interceptor] needs
  ///an insatnce of [Dio], use [AveoApiInterceptors.dio]
  static List<Interceptor> interceptors = [];
  static BaseOptions? baseOptions;
  static Dio? dio;
  static Map<String, AuthInterceptorData> authTnterceptorMap = {};
  static Dio make() {
    dio?.interceptors.addAll(interceptors);
    dio?.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          compact: false,
          maxWidth: 80,
          error: true),
    );
    return dio!;
  }
}
