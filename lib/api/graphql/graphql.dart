part of 'package:avio/avio.dart';

mixin GQL {
  final CLStatus controller = CLStatus.instance;
  void graphQL({
    required String document,
    required String serviceUrl,
    required bool showLoader,
    required GQLmethod methodType,
    required Function(int? statusCode, Map<String, dynamic> data) success,
    Function(int? statusCode, Map<String, dynamic> error)? error,
    Map<String, dynamic> variables = const {},
    Map<String, String>? header,
    ErrorPolicy? errorPolicy,
    FetchPolicy? fetchPolicy,
    CacheRereadPolicy? cacheRereadPolicy,
    Object? Function(Map<String, dynamic>)? parserFn,
    Duration? pollInterval,
    Object? optimisticResult,
    String? opertationName,
  }) async {
    if (controller.isConnected().value) {
      try {
        if (showLoader) {
          controller.isLoading.value = true;
        }
        if (methodType == GQLmethod.query) {
          QueryResult<Object?> response =
              await GQLconfig.getGQLclient(url: serviceUrl, header: header)
                  .runQuery(
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
            timeout: (timeoutMessage) => ApiCall.instance.dioErrorCall(
                dioErrorType: DioErrorType.connectTimeout, error: error),
          );
          if (response.hasException) {
            error?.call(null, {
              'title': 'Error',
              'message': response.exception,
            });
          } else {
            success.call(200, response.data ?? {});
          }
        }
        if (methodType == GQLmethod.mutation) {
          QueryResult<Object?> response =
              await GQLconfig.getGQLclient(url: serviceUrl, header: header)
                  .runMutation(
            MutationOptions(
                document: gql(document),
                variables: variables,
                operationName: opertationName,
                errorPolicy: errorPolicy,
                fetchPolicy: fetchPolicy,
                cacheRereadPolicy: cacheRereadPolicy,
                parserFn: parserFn,
                optimisticResult: optimisticResult),
            timeout: (timeoutMessage) => ApiCall.instance.dioErrorCall(
                dioErrorType: DioErrorType.connectTimeout, error: error),
          );
          if (response.hasException) {
            error?.call(null, {
              'title': 'Error',
              'message': response.exception,
            });
          } else {
            success.call(200, response.data ?? {});
          }
        }
        if (methodType == GQLmethod.stream) {
          Stream<QueryResult<Object?>> response =
              await GQLconfig.getGQLclient(url: serviceUrl, header: header)
                  .runSubscribe(
                      SubscriptionOptions(
                          document: gql(document),
                          variables: variables,
                          operationName: opertationName,
                          errorPolicy: errorPolicy,
                          fetchPolicy: fetchPolicy,
                          cacheRereadPolicy: cacheRereadPolicy,
                          parserFn: parserFn,
                          optimisticResult: optimisticResult),
                      timeout: (timeoutMessage) => ApiCall.instance
                          .dioErrorCall(
                              dioErrorType: DioErrorType.connectTimeout,
                              error: error));
          success.call(null, {'tittle': 'Success', 'message': response});
        }
      } catch (e) {
        error?.call(
            null, {'tittle': 'Error', 'message': 'Something went wrong'});
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
