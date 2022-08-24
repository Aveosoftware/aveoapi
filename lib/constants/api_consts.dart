part of 'package:avio/avio.dart';

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
