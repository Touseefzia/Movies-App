import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../bottom_nav_bar/bottom_nav_bar_controller.dart';
import '../database_drift/database.dart';
import '../dio_apis/api_client.dart';
import '../dio_apis/api_repo.dart';


class Utility {

  static BtmNavBarController btmNavBarController = Get.put(BtmNavBarController());
  static AppDatabase database = AppDatabase();
  static final retrofitClient = ApiClient(Dio(BaseOptions(contentType: "application/json")));
  static ApisRepo apisRepo = ApisRepo();


  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static sortMovies(){
    if(Utility.btmNavBarController.sortingPreference.value == "popularity"){
      Utility.btmNavBarController.movieStream
          .sort((movieOne, movieTow) {
        return ((movieTow.popularity ?? 2)  ~/ 1)
            .compareTo((movieOne.popularity ?? 2)  ~/ 1);
      });
    }else if(Utility.btmNavBarController.sortingPreference.value == "rating"){
      Utility.btmNavBarController.movieStream
          .sort((movieOne, movieTow) {
        return ((movieTow.voteAverage ?? 2)  ~/ 1)
            .compareTo((movieOne.voteAverage ?? 2)  ~/ 1);
      });
    }else if(Utility.btmNavBarController.sortingPreference.value == "newest first"){
      Utility.btmNavBarController.movieStream
          .sort((movieOne, movieTow) {
        return (DateTime.tryParse(movieTow.releaseDate ?? "")?.millisecondsSinceEpoch ?? 1)
        .compareTo((DateTime.tryParse(movieOne.releaseDate ?? "")?.millisecondsSinceEpoch ?? 1))
        ;
      });
    }else if(Utility.btmNavBarController.sortingPreference.value == "oldest first"){
      Utility.btmNavBarController.movieStream
          .sort((movieOne, movieTow) {
        return (DateTime.tryParse(movieOne.releaseDate ?? "")?.millisecondsSinceEpoch ?? 1)
        .compareTo((DateTime.tryParse(movieTow.releaseDate ?? "")?.millisecondsSinceEpoch ?? 1))
        ;
      });
    }
  }
}