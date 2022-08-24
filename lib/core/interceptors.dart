part of 'package:avio/avio.dart';

class AvioInterceptors {
  AvioInterceptors._instance();
  static AvioInterceptors get instance => AvioInterceptors._instance();
  factory AvioInterceptors(
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
  ///an insatnce of [Dio], use [AvioInterceptors.dio]
  static List<Interceptor> interceptors = [];
  static BaseOptions? baseOptions;
  static Dio? dio;
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
