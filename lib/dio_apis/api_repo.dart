
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../database_drift/database.dart';
import '../models/credits_model.dart';
import '../models/movie_detail_model.dart';
import '../utilities/utility.dart';

class ApisRepo {
  static String TAG = "ApisRepo";

  Future<List<Movie>?> fetchMovies() async {
    try {
      var it = await Utility.retrofitClient.fetchHomeData();
      log("$TAG fetchMovies: Here is \n ${it['success']} \n ${it['trandingMovies']}");
      var list = it['trandingMovies'];
      List<Movie> movieList = [];
      for (var movie in list) {
        movieList.add(Movie.fromJson(movie));
      }
      log("$TAG fetchMovies: Here is movieList \n $movieList");

      return movieList;
    } catch (obj) {
      log("$TAG: fetchMovies: In catchError ${obj.toString()}");
      log("$TAG: fetchMovies: In catchError 2 ${obj.printError}");
      switch (obj.runtimeType) {
        case DioException:
          final res = (obj as DioException).response;
          log("$TAG: fetchMovies: Status Message: ${res?.statusMessage} Code: ${res?.statusCode} Data: ${res?.data} Extras: ${res?.extra}");
          break;
      }
      return null;
    }
  }




  Future<MovieDetailModel?> fetchMovieDetail({required int movieId}) async{
    try{
      var it = await Utility.retrofitClient.fetchMovieDetail(movieId: movieId);
      log("$TAG fetchMovieDetail: Here is \n ${it['success']}}");
      MovieDetailModel movieDetailModel = MovieDetailModel.fromJson(it['data']);
      CreditsModel creditsModel = CreditsModel.fromJson(it['credits']);
      movieDetailModel.credits = creditsModel;

      log("$TAG fetchMovieDetail: Here is movieList \n $movieDetailModel");

      return movieDetailModel;
    }catch (obj) {
      log("$TAG: fetchMovieDetail: In catchError ${obj.toString()}");
      log("$TAG: fetchMovieDetail: In catchError 2 ${obj.printError}");
      switch (obj.runtimeType) {
        case DioException:
          final res = (obj as DioException).response;
          log("$TAG: fetchMovieDetail: Status Message: ${res?.statusMessage} Code: ${res?.statusCode} Data: ${res?.data} Extras: ${res?.extra}");
          break;
      }
      return null;
    }
  }


}