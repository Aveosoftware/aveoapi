import 'package:avio/avio.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AuthInterceptorData? authdata =
        AvioInterceptors.authTnterceptorMap[options.baseUrl];
    if (authdata != null) {
      options.headers['Authorization'] = 'Bearer ${authdata.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    AuthInterceptorData? authdata =
        AvioInterceptors.authTnterceptorMap[err.requestOptions.baseUrl];
    if (authdata != null) {
      if (err.response?.statusCode == authdata.accessTokenExpireCode) {
        Response response = await Dio().post(
            err.requestOptions.baseUrl + authdata.refreshTokenEndpoint,
            data: {authdata.refreshParamName: authdata.refreshToken});
        switch (response.statusCode) {
          case 200:
            authdata.onSuccess.call(response.data).then((newAuthData) {
              AvioInterceptors.authTnterceptorMap[err.requestOptions.baseUrl] =
                  newAuthData;
              handler.resolve(retry(err.requestOptions, newAuthData));
            });
            break;
          default:
            authdata.onRefeshTokenExpire.call();
            handler.next(err);
        }
      }
    }
    // super.onError(err, handler);
  }
}

retry(RequestOptions requestOptions, AuthInterceptorData newAuthData) async {
  Map<String, dynamic> header = requestOptions.headers;
  header['Authorization'] = 'Bearer ${newAuthData.accessToken}';
  return await Dio().request(requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
          method: requestOptions.method, headers: requestOptions.headers));
}

class AuthInterceptorData {
  final String accessToken,
      refreshToken,
      refreshTokenEndpoint,
      refreshParamName;
  final int accessTokenExpireCode, refreshTokenExpireCode;
  final Function onRefeshTokenExpire;
  final TokenResponce onSuccess;
  const AuthInterceptorData({
    required this.accessToken,
    required this.accessTokenExpireCode,
    required this.refreshToken,
    required this.refreshTokenExpireCode,
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
      refreshTokenExpireCode: refreshTokenExpireCode,
      onSuccess: onSuccess,
      onRefeshTokenExpire: onRefeshTokenExpire,
      refreshTokenEndpoint: refreshTokenEndpoint,
      refreshParamName: refreshParamName,
    );
  }
}

typedef TokenResponce = Future<AuthInterceptorData> Function(
    Map<String, dynamic>);
