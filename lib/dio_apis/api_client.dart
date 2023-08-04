import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import 'api_const.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(ApiConst.fetchHome)
  Future<dynamic> fetchHomeData();

  @GET("${ApiConst.fetchMovieDetail}/{movieId}")
  Future<dynamic> fetchMovieDetail({@Path() required int movieId});
}