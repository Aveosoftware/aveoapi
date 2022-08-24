part of 'package:avio/avio.dart';

typedef GetHeaders = Future<Map<String, String>> Function();
typedef _RequestTransformer = FutureOr<Request> Function(Request request);

class CustomAuthLink extends _AsyncReqTransformLink {
  CustomAuthLink({
    required this.getHeaders,
  }) : super(requestTransformer: transform(getHeaders));

  final Map<String, String>? Function() getHeaders;

  static _RequestTransformer transform(
    Map<String, String>? Function() getHeaders,
  ) =>
      (Request request) {
        final Map<String, String>? headers = getHeaders();
        return request.updateContextEntry<dio_link.HttpLinkHeaders>(
          (_headers) => dio_link.HttpLinkHeaders(
            headers: headers!,
          ),
        );
      };
}

class _AsyncReqTransformLink extends Link {
  final _RequestTransformer requestTransformer;

  _AsyncReqTransformLink({
    required this.requestTransformer,
  });

  @override
  Stream<gql_obj.Response> request(
    Request request, [
    NextLink? forward,
  ]) async* {
    final req = await requestTransformer(request);

    yield* forward!(req);
  }
}
