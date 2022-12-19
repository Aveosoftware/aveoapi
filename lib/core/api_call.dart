part of 'package:aveo_api/aveo_api.dart';

class ApiCall with REST, GQL {
  ApiCall._instance();
  static ApiCall get instance => ApiCall._instance();

  void dioErrorCall({
    required DioErrorType dioErrorType,
    Function(int?, Map<String, dynamic>)? error,
  }) {
    switch (dioErrorType) {
      case DioErrorType.other:
        error?.call(null, {
          'title': StringAssets.labelConnectionError,
          'message': StringAssets.labelErrorWhileMakingRequest,
        });
        break;
      case DioErrorType.connectTimeout:
        error?.call(null, {
          'title': StringAssets.labelConnectionTimeout,
          'message': StringAssets.labelFailedToConnectToServer,
        });
        break;
      case DioErrorType.response:
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.receiveTimeout:
        error?.call(null, {
          'title': StringAssets.labelConnectionTimeout,
          'message': StringAssets.labelFailedToRetriveDataFromTheServer,
        });
        break;
      case DioErrorType.sendTimeout:
        error?.call(408, {
          'title': StringAssets.labelConnectionTimeout,
          'message': StringAssets.labelFailedToSendDataToTheServer,
        });
        break;
      default:
        error?.call(null, {
          'title': StringAssets.labelConnectionError,
          'message': StringAssets.labelErrorWhileMakingRequest,
        });
        break;
    }
  }
}
