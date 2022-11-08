part of 'package:avio/avio.dart';

class Avio {
  ///This initialises [CLStatus] to keep track of connectivity status and loader
  ///and adds created dio instance with [BaseOptions].
  ///To add dio intereptors, after the [Avio.init] constructor is called, assign
  ///list of interceptors to [AvioInterceptors.interceptors]
  Avio() {
    Avio.init();
  }

  ///This initialises [CLStatus] to keep track of connectivity status and loader
  ///and adds created dio instance with [BaseOptions].
  ///To add dio intereptors, after the [Avio.init] constructor is called, assign
  ///list of interceptors to [AvioInterceptors.interceptors]
  Avio.init({
    BaseOptions? baseOptions,
  }) {
    CLStatus();
    AvioInterceptors(baseOptions: baseOptions);
  }
}
