part of 'package:aveo_api/aveo_api.dart';

class GQLconfig {
  static GQLclient getGQLclient({
    required String url,
    Map<String, String>? header,
  }) {
    final ErrorLink errorLink =
        ErrorLink(onGraphQLError: (request, requestStream, response) {
      if (response.errors != null) {
        for (var error in response.errors!) {
          log('[GraphQL error]: Message: ${error.message}, Location: ${error.locations}, Path: ${error.path}');
        }
      }
      // else if (response. != null &&
      //     response.exception.clientException != null) {
      //   print(
      //       '[GraphQL error]: Message: ${response.exception.clientException.message}');
      // }

      return Stream.value(response);
      //print('StatusCode: ${response.fetchResult.statusCode}');
    });

    /*Link loggingLink = Link(request: (
      Operation operation, [
      NextLink forward,
    ]) {
      StreamController<FetchResult> controller;

      Future<void> onListen() async {
        await controller.addStream(forward(operation));
        for (var response in operation.getContext().values) {
          if (response is Response) {
            print("Interceptor: ${response.data}");
          }
        }

        for (var response in operation.getContext().values) {
          if (response is Response) {
            print("Interceptor: ${response.data}");
          }

        }

        await controller.close();
      }

      controller = StreamController<FetchResult>(onListen: onListen);

      return controller.stream;
    });*/

    return GQLclient(
      defaultPolicies:
          DefaultPolicies(query: Policies(fetch: FetchPolicy.networkOnly)),
      link: errorLink.concat(CustomAuthLink(getHeaders: () {
        return header ?? <String, String>{};
      })).concat(DioLink(url,
          client: AveoApiInterceptors.dio!,
          defaultHeaders: header ?? <String, String>{})),
      cache: GraphQLCache(),
    );
  }
}
