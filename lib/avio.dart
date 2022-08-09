library avio;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avio/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_obj;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:gql_dio_link/gql_dio_link.dart' as dio_link;
import 'package:graphql/client.dart';
import 'package:graphql/client.dart' as gql_obj;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'package:avio/widgets/cl_wrapper.dart';
part 'package:avio/api/api_consts.dart';
part 'package:avio/core/api_call.dart';
part 'package:avio/core/connection_loader.dart';
part 'package:avio/core/interceptors.dart';
part 'package:avio/core/constructor.dart';
part 'package:avio/api/graphql/gql_auth_link.dart';
part 'package:avio/api/graphql/gql_client.dart';
part 'package:avio/api/graphql/gql_config.dart';
