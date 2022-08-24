part of 'package:avio/avio.dart';

mixin REST {
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
        ApiCall.instance.dioErrorCall(dioErrorType: e.type, error: error);
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
}
