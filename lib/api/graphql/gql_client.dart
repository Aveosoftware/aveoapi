part of 'package:avio/avio.dart';

class GQLclient extends GraphQLClient {
  DefaultPolicies? defaultPolicie;

  GQLclient({required link, required cache, defaultPolicies})
      : super(cache: cache, link: link, defaultPolicies: defaultPolicies) {
    // defaultPolicies;
    // queryManager = QueryManager(
    //   link: link,
    //   cache: cache,
    // );
  }

  // /// The default [Policies] to set for each client action
  // DefaultPolicies? defaultPolicies;

  // /// The [Link] over which GraphQL documents will be resolved into a [FetchResult].
  // Link link;

  // /// The initial [Cache] to use in the data store.
  // GraphQLCache cache;

  Future<QueryResult> runQuery(QueryOptions options,
      {int timeoutMS = 15000, Function(String timeoutMessage)? timeout}) async {
    return query(options).timeout(Duration(milliseconds: timeoutMS),
        onTimeout: () {
      timeout?.call("Query timed out after $timeoutMS ms");
      return QueryResult(options: options, source: QueryResultSource.network);
    });
  }

  Future<QueryResult> runMutation(MutationOptions options,
      {int timeoutMS = 15000, Function(String timeoutMessage)? timeout}) async {
    return mutate(options).timeout(Duration(milliseconds: timeoutMS),
        onTimeout: () {
      timeout?.call("Mutation timed out after $timeoutMS ms");
      return QueryResult(options: options, source: QueryResultSource.network);
    });
  }

  Future<Stream<QueryResult<Object?>>> runSubscribe(SubscriptionOptions options,
      {int timeoutMS = 15000, Function(String timeoutMessage)? timeout}) async {
    return subscribe(options).timeout(Duration(milliseconds: timeoutMS),
        onTimeout: (eventSink) {
      timeout?.call("Mutation timed out after $timeoutMS ms");
      eventSink.close();
    });
  }
}
