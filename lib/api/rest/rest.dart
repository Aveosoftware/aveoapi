part of 'package:aveo_api/aveo_api.dart';

mixin REST {
  final CLStatus controller = CLStatus.instance;
  Future<bool> rest({
    required Map<String, dynamic> params,
    required String serviceUrl,
    required bool showLoader,
    required RestMethod methodType,
    required Function(int? statusCode, dynamic data) success,
    Function(int? statusCode, dynamic error)? error,
    ResponseType returnType = ResponseType.json,
    List<int> successStatusCodes = const [200],
    Map<String, dynamic>? header,
    FormData? formValues,
  }) async {
    if (controller.isConnected.value) {
      try {
        if (showLoader) {
          controller.isLoading.value = true;
        }
        Map<String, dynamic> headerParameters = {};
        if (header != null) {
          headerParameters.addEntries(header.entries);
        }

        // ignore: always_specify_types
        dio_obj.Response response;
        if (methodType == RestMethod.get) {
          response = await AveoApiInterceptors.make().get(serviceUrl,
              queryParameters: params,
              options: Options(
                headers: headerParameters,
                responseType: returnType,
              ));
        } else if (methodType == RestMethod.put) {
          response = await AveoApiInterceptors.make().put(serviceUrl,
              data: params,
              options: Options(
                headers: headerParameters,
                responseType: returnType,
              ));
        } else if (methodType == RestMethod.delete) {
          response = await AveoApiInterceptors.make().delete(serviceUrl,
              data: params, options: Options(headers: headerParameters));
        } else if (methodType == RestMethod.patch) {
          response = await AveoApiInterceptors.make().patch(serviceUrl,
              data: params, options: Options(headers: headerParameters));
        } else {
          response = await AveoApiInterceptors.make().post(serviceUrl,
              data: formValues ?? params,
              options: Options(
                headers: headerParameters,
                responseType: returnType,
              ));
        }

        //Here you can handle errors based on statusCode
        if (successStatusCodes.contains(response.statusCode)) {
          success.call(response.statusCode, response.data);
          return true;
        } else {
          error?.call(response.statusCode, response.data);
          return false;
        }
      } on DioError catch (e) {
        ApiCall.instance.dioErrorCall(dioErrorType: e.type, error: error);
        return false;
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
      return false;
    }
  }
}
