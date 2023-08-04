import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/database_drift/database.dart';
import 'package:movies_app/dio_apis/api_const.dart';
import 'package:movies_app/screens/settings_screen.dart';
import '../utilities/color_values.dart';
import '../utilities/pixels.dart';
import '../utilities/reusable_widgets.dart';
import '../utilities/star_icon_display.dart';
import '../utilities/utility.dart';
import 'movie_detail_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
    final TAG = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
            backgroundColor: ColorValues.whiteColor,
          appBar: ReusableWidgets.appBarWidget(
              context: context,
              title: "Discover",
              isBottomNavScreen: true,
              showIcon: ReusableWidgets.childButtonWidget(onButtonPress: (){Get.to(()=> SettingsScreen());},
                  child: const Icon(Icons.settings, color: ColorValues.mainColor,), bgColor: ColorValues.whiteColor) ,
              onBackPress: (){Get.back();}),
          body: Padding(
            padding: const EdgeInsets.only(left: Pixels.screenPadding, right: Pixels.screenPadding),
            child: FutureBuilder<List<Movie>?>(
                future: fetchMovies(),
                builder: (ctx, AsyncSnapshot<List<Movie>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Some Error',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<Movie>? movies = snapshot.data;

                      if (movies != null) {
                        Utility.btmNavBarController.movieStream.value = movies;
                        log("//////////////////////////////////////// sortingPreference = ${Utility.btmNavBarController.sortingPreference.value}\n ${Utility.btmNavBarController.sortingPreference.value == "popularity"}");
                        Utility.sortMovies();
                      }
                      return Obx(() => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: Utility.btmNavBarController.movieStream.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        if(Utility.btmNavBarController.movieStream.isNotEmpty){
                                          Get.to(()=> MovieDetailScreen(movie: Utility.btmNavBarController.movieStream[index],));
                                        }
                                      },
                                      child: SizedBox(
                                        height: 200,
                                        width: 130,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: "${ApiConst.imageBaseUrl}${Utility.btmNavBarController.movieStream[index].posterPath ?? ""}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    SizedBox(
                                      width: constraints.maxWidth - (140 + (2*Pixels.screenPadding)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ReusableWidgets.textWidget(text: Utility.btmNavBarController.movieStream[index].originalTitle ?? "",
                                            textColor: ColorValues.darkTextColor, fontSize: Pixels.smallTextSize,maxLine: 1),
                                          const SizedBox(height: Pixels.labelToTextField,),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              IconTheme(
                                                data: const IconThemeData(
                                                  color: ColorValues.mainColor,
                                                  size: 20,
                                                ),
                                                child: StarDisplay(
                                                  value: (movies?[index].voteAverage?? 2) ~/ 2
                                                ),
                                              ),
                                              ReusableWidgets.textWidget(
                                                  text: " ${Utility.btmNavBarController.movieStream[index].voteAverage.toString()}/10",
                                                  textColor: ColorValues.mainColor,
                                                  fontSize: Pixels.smallTextSize,

                                              )
                                            ],
                                          ),

                                          const SizedBox(height: Pixels.labelToTextField,),

                                          ReusableWidgets.textWidget(
                                            text: " ${Utility.btmNavBarController.movieStream[index].popularity.toString()}",
                                            textColor: ColorValues.mainColor,
                                            fontSize: Pixels.smallTextSize,

                                          ),
                                          const SizedBox(height: Pixels.labelToTextField,),
                                          ReusableWidgets.textWidget(text: movies?[index].releaseDate ?? "",
                                            textColor: ColorValues.darkTextColor, fontSize: Pixels.smallTextSize,maxLine: 1),
                                  ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                                ReusableWidgets.textWidget(text: movies?[index].originalTitle ?? "", textColor: ColorValues.mainColor, fontSize: 12);
                            },
                          ),);
                    }
                  }
                  return ReusableWidgets.loadingWidget(text: "Please Wait", constraints: constraints);
                }),
          ),

            );
      },
    );
  }

  Future<List<Movie>?> fetchMovies() async{
    try{
      var it = await Utility.retrofitClient.fetchHomeData();
      log("$TAG fetchMovies: Here is \n ${it['success']} \n ${it['trandingMovies']}");
      var list = it['trandingMovies'];
      List<Movie> movieList = [];
      for(var movie in list){
        movieList.add(Movie.fromJson(movie));
      }
      // var movieList = list.map( (e) => Movie.fromJson(e)).toList(growable: false);
      log("$TAG fetchMovies: Here is movieList \n $movieList");

      return movieList;
    }catch (obj) {
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


}
