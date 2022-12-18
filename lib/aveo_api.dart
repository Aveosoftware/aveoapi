library aveo_api;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:aveo_api/api/rest/auth_header_interseptor.dart';
import 'package:aveo_api/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_obj;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:gql_dio_link/gql_dio_link.dart' as dio_link;
import 'package:graphql/client.dart';
import 'package:graphql/client.dart' as gql_obj;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
export 'package:dio/src/multipart_file.dart';

part 'package:aveo_api/widgets/cl_wrapper.dart';
part 'package:aveo_api/constants/api_consts.dart';
part 'package:aveo_api/core/api_call.dart';
part 'package:aveo_api/core/connection_loader.dart';
part 'package:aveo_api/core/interceptors.dart';
part 'package:aveo_api/core/constructor.dart';
part 'package:aveo_api/api/graphql/gql_auth_link.dart';
part 'package:aveo_api/api/graphql/gql_client.dart';
part 'package:aveo_api/api/graphql/gql_config.dart';
part 'package:aveo_api/api/rest/rest.dart';
part 'package:aveo_api/api/graphql/graphql.dart';
