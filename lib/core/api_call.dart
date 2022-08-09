part of 'package:avio/avio.dart';

class ApiCall {
  ApiCall._instance();
  static ApiCall get instance => ApiCall._instance();
  final CLStatus controller = CLStatus.instance;
  void rest({
    required Map<String, dynamic> params,
    required String serviceUrl,
    required bool showLoader,
    required RestMethod methodType,
    required Function(int?, Map<String, dynamic>) success,
    Function(int?, Map<String, dynamic>)? error,
    Function(int?, dynamic)? invalidResponse,
    ReturnType returnType = ReturnType.map,
    List<int> successStatusCodes = const [200],
    Map<String, dynamic>? header,
    FormData? formValues,
  }) async {
    if (controller.isConnected().value) {
      try {
        if (showLoader) {
          controller.isLoading.value = true;
        }
        if (formValues != null) {
          for (int i = 0; i < formValues.files.length; i++) {
            formValues.files.add(MapEntry<String, MultipartFile>(
                formValues.files[i].key, formValues.files[i].value));
          }
        }
        Map<String, dynamic> headerParameters = {};
        if (header != null) {
          headerParameters.addEntries(header.entries);
        }

        // ignore: always_specify_types
        dio_obj.Response response;
        if (methodType == RestMethod.get) {
          response = await AvioInterceptors.make().get(serviceUrl,
              queryParameters: params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        } else if (methodType == RestMethod.put) {
          response = await AvioInterceptors.make().put(serviceUrl,
              data: params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        } else if (methodType == RestMethod.delete) {
          response = await AvioInterceptors.make().delete(serviceUrl,
              data: params, options: Options(headers: headerParameters));
        }
        // else if (methodType == RestMethod.download) {
        // response = await AvioInterceptors.make().download(serviceUrl,
        //     data: params, options: Options(headers: headerParameters));
        // }
        else if (methodType == RestMethod.patch) {
          response = await AvioInterceptors.make().patch(serviceUrl,
              data: params, options: Options(headers: headerParameters));
        } else {
          response = await AvioInterceptors.make().post(serviceUrl,
              data: formValues ?? params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        }

        //Here you can handle errors based on statusCode
        if (successStatusCodes.contains(response.statusCode)) {
          try {
            if (returnType == ReturnType.string && response.data is String) {
              success.call(response.statusCode, response.data);
            } else {
              if (response.data is Map<String, dynamic>) {
                success.call(response.statusCode, response.data);
              } else {
                success.call(response.statusCode, jsonDecode(response.data));
              }
            }
          } catch (_) {
            invalidResponse?.call(response.statusCode, response.data);
          }
        } else {
          try {
            if (response.data is Map<String, dynamic>) {
              error?.call(response.statusCode, response.data);
            } else {
              error?.call(response.statusCode, jsonDecode(response.data));
            }
          } catch (_) {
            invalidResponse?.call(response.statusCode, response.data);
          }
        }
      } on DioError catch (e) {
        dioErrorCall(dioErrorType: e.type, error: error);
      } finally {
        if (showLoader) {
          controller.isLoading.value = false;
        }
      }
    } else {
      error?.call(null, {
        'title': 'No internet access',
        'message':
            'Could not connect to server, please check your network connection'
      });
    }
  }

  void graphQL({
    required String document,
    required String serviceUrl,
    required bool showLoader,
    required GQLmethod methodType,
    required Function(int?, Map<String, dynamic>) success,
    Function(int?, Map<String, dynamic>)? error,
    Function(int?, dynamic)? invalidResponse,
    Map<String, dynamic> variables = const {},
    ReturnType returnType = ReturnType.map,
    List<int> successStatusCodes = const [200],
    Map<String, String>? header,
    ErrorPolicy? errorPolicy,
    FetchPolicy? fetchPolicy,
    CacheRereadPolicy? cacheRereadPolicy,
    Object? Function(Map<String, dynamic>)? parserFn,
    Duration? pollInterval,
    Object? optimisticResult,
    String? opertationName,
  }) {
    if (controller.isConnected().value) {
      try {
        if (showLoader) {
          controller.isLoading.value = true;
        }
        if (methodType == GQLmethod.quey) {
          GQLconfig.getGQLclient(url: serviceUrl, header: header).runQuery(
            QueryOptions(
                document: gql(document),
                variables: variables,
                operationName: opertationName,
                errorPolicy: errorPolicy,
                fetchPolicy: fetchPolicy,
                cacheRereadPolicy: cacheRereadPolicy,
                pollInterval: pollInterval,
                parserFn: parserFn,
                optimisticResult: optimisticResult),
            timeout: (timeoutMessage) => dioErrorCall(
                dioErrorType: DioErrorType.connectTimeout, error: error),
          );
        }
        if (methodType == GQLmethod.mutation) {
          GQLconfig.getGQLclient(url: serviceUrl, header: header).runMutation(
            MutationOptions(
                document: gql(document),
                variables: variables,
                operationName: opertationName,
                errorPolicy: errorPolicy,
                fetchPolicy: fetchPolicy,
                cacheRereadPolicy: cacheRereadPolicy,
                parserFn: parserFn,
                optimisticResult: optimisticResult),
            timeout: (timeoutMessage) => dioErrorCall(
                dioErrorType: DioErrorType.connectTimeout, error: error),
          );
        }
        if (methodType == GQLmethod.stream) {
          GQLconfig.getGQLclient(url: serviceUrl, header: header).runSubscribe(
              SubscriptionOptions(
                  document: gql(document),
                  variables: variables,
                  operationName: opertationName,
                  errorPolicy: errorPolicy,
                  fetchPolicy: fetchPolicy,
                  cacheRereadPolicy: cacheRereadPolicy,
                  parserFn: parserFn,
                  optimisticResult: optimisticResult),
              timeout: (timeoutMessage) => dioErrorCall(
                  dioErrorType: DioErrorType.connectTimeout, error: error));
        }
      } catch (e) {
      } finally {
        if (showLoader) {
          controller.isLoading.value = false;
        }
      }
    } else {
      error?.call(null, {
        'title': 'No internet access',
        'message':
            'Could not connect to server, please check your network connection'
      });
    }
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
