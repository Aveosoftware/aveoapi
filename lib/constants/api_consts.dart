part of 'package:aveo_api/aveo_api.dart';

enum RestMethod {
  post,
  get,
  put,
  delete,
  // download,
  patch,
}

enum GQLmethod { query, mutation, stream }

enum ReturnType {
  string,
  map,
}
