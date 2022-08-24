part of 'package:avio/avio.dart';

class ApiCall with REST, GQL {
  ApiCall._instance();
  static ApiCall get instance => ApiCall._instance();

  @override
  void rest(
      {required Map<String, dynamic> params,
      required String serviceUrl,
      required bool showLoader,
      required RestMethod methodType,
      required Function(int? p1, Map<String, dynamic> p2) success,
      Function(int? p1, Map<String, dynamic> p2)? error,
      Function(int? p1, dynamic p2)? invalidResponse,
      ReturnType returnType = ReturnType.map,
      List<int> successStatusCodes = const [200],
      Map<String, dynamic>? header,
      FormData? formValues}) {
    super.rest(
        params: params,
        serviceUrl: serviceUrl,
        showLoader: showLoader,
        methodType: methodType,
        success: success,
        error: error,
        invalidResponse: invalidResponse,
        returnType: returnType,
        successStatusCodes: successStatusCodes,
        header: header,
        formValues: formValues);
  }

  @override
  void graphQL(
      {required String document,
      required String serviceUrl,
      required bool showLoader,
      required GQLmethod methodType,
      required Function(int? p1, Map<String, dynamic> p2) success,
      Function(int? p1, Map<String, dynamic> p2)? error,
      Map<String, dynamic> variables = const {},
      Map<String, String>? header,
      ErrorPolicy? errorPolicy,
      FetchPolicy? fetchPolicy,
      CacheRereadPolicy? cacheRereadPolicy,
      Object? Function(Map<String, dynamic> p1)? parserFn,
      Duration? pollInterval,
      Object? optimisticResult,
      String? opertationName}) {
    super.graphQL(
        document: document,
        serviceUrl: serviceUrl,
        showLoader: showLoader,
        methodType: methodType,
        success: success,
        error: error,
        variables: variables,
        header: header,
        errorPolicy: errorPolicy,
        fetchPolicy: fetchPolicy,
        cacheRereadPolicy: cacheRereadPolicy,
        parserFn: parserFn,
        pollInterval: pollInterval,
        optimisticResult: optimisticResult,
        opertationName: opertationName);
  }

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
