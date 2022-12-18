part of 'package:aveo_api/aveo_api.dart';

class AveoApi {
  ///This initialises [CLStatus] to keep track of connectivity status and loader
  ///and adds created dio instance with [BaseOptions].
  ///To add dio intereptors, after the [AveoApi.init] constructor is called, assign
  ///list of interceptors to [AveoApiInterceptors.interceptors]
  AveoApi() {
    AveoApi.init();
  }

  ///This initialises [CLStatus] to keep track of connectivity status and loader
  ///and adds created dio instance with [BaseOptions].
  ///To add dio intereptors, after the [AveoApi.init] constructor is called, assign
  ///list of interceptors to [AveoApiInterceptors.interceptors]
  AveoApi.init({
    BaseOptions? baseOptions,
  }) {
    CLStatus();
    AveoApiInterceptors(baseOptions: baseOptions);
  }
}
