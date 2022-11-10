import 'package:avio/avio.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Iterable<MapEntry<String, AuthInterceptorData>> authdata =
        AvioInterceptors.authTnterceptorMap.entries.where(
      (e) => options.path.contains(e.key),
    );

    if (authdata.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer ${authdata.first.value.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response err, ResponseInterceptorHandler handler) async {
    Iterable<MapEntry<String, AuthInterceptorData>> authdata =
        AvioInterceptors.authTnterceptorMap.entries.where(
      (e) => err.requestOptions.path.contains(e.key),
    );
    if (authdata.isNotEmpty) {
      if (err.statusCode == authdata.first.value.accessTokenExpireCode) {
        try {
          Response response = await Dio().post(
              authdata.first.key + authdata.first.value.refreshTokenEndpoint,
              data: {
                authdata.first.value.refreshParamName:
                    authdata.first.value.refreshToken
              });
          switch (response.statusCode) {
            case 200:
              authdata.first.value.onSuccess
                  .call(response.data)
                  .then((newAuthData) async {
                AvioInterceptors.authTnterceptorMap[authdata.first.key] =
                    newAuthData;
                try {
                  var resp = await retry(err.requestOptions, newAuthData);
                  handler.next(resp);
                } on DioError catch (_) {
                  handler.reject(_);
                }
              });
              break;
            default:
              authdata.first.value.onRefeshTokenExpire.call();
              handler.next(err);
          }
        } catch (_) {
          authdata.first.value.onRefeshTokenExpire.call();
          handler.next(err);
        }
      } else {
        super.onResponse(err, handler);
      }
    } else {
      super.onResponse(err, handler);
    }
    // super.onError(err, handler);
  }

  // @override
  // void onError(DioError err, ErrorInterceptorHandler handler) async {
  //   Iterable<MapEntry<String, AuthInterceptorData>> authdata =
  //       AvioInterceptors.authTnterceptorMap.entries.where(
  //     (e) => err.requestOptions.path.contains(e.key),
  //   );
  //   if (authdata.isNotEmpty) {
  //     if (err.response?.statusCode ==
  //         authdata.first.value.accessTokenExpireCode) {
  //       Response response = await Dio().post(
  //           err.requestOptions.baseUrl +
  //               authdata.first.value.refreshTokenEndpoint,
  //           data: {
  //             authdata.first.value.refreshParamName:
  //                 authdata.first.value.refreshToken
  //           });
  //       switch (response.statusCode) {
  //         case 200:
  //           authdata.first.value.onSuccess
  //               .call(response.data)
  //               .then((newAuthData) {
  //             AvioInterceptors.authTnterceptorMap[err.requestOptions.baseUrl] =
  //                 newAuthData;
  //             handler.resolve(retry(err.requestOptions, newAuthData));
  //           });
  //           break;
  //         default:
  //           authdata.first.value.onRefeshTokenExpire.call();
  //           handler.next(err);
  //       }
  //     }
  //   }
  //   // super.onError(err, handler);
  // }
}

retry(RequestOptions requestOptions, AuthInterceptorData newAuthData) async {
  Map<String, dynamic> header = requestOptions.headers;
  header['Authorization'] = 'Bearer ${newAuthData.accessToken}';
  Response response = await Dio().request(requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(method: requestOptions.method, headers: header));
  return response;
}

class AuthInterceptorData {
  final String accessToken,
      refreshToken,
      refreshTokenEndpoint,
      refreshParamName;
  final int accessTokenExpireCode;
  final ExpireTokenResponce onRefeshTokenExpire;
  final TokenResponce onSuccess;
  const AuthInterceptorData({
    required this.accessToken,
    required this.accessTokenExpireCode,
    required this.refreshToken,
    required this.onSuccess,
    required this.onRefeshTokenExpire,
    required this.refreshTokenEndpoint,
    required this.refreshParamName,
  });

  AuthInterceptorData copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthInterceptorData(
      accessToken: accessToken ?? this.accessToken,
      accessTokenExpireCode: accessTokenExpireCode,
      refreshToken: refreshToken ?? this.refreshToken,
      onSuccess: onSuccess,
      onRefeshTokenExpire: onRefeshTokenExpire,
      refreshTokenEndpoint: refreshTokenEndpoint,
      refreshParamName: refreshParamName,
    );
  }
}

typedef TokenResponce = Future<AuthInterceptorData> Function(
    Map<String, dynamic> successData);
typedef ExpireTokenResponce = void Function();
