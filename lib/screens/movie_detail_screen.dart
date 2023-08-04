import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/dio_apis/api_const.dart';
import '../database_drift/database.dart';
import '../models/movie_detail_model.dart';
import '../utilities/color_values.dart';
import '../utilities/pixels.dart';
import '../utilities/reusable_widgets.dart';
import '../utilities/star_icon_display.dart';
import '../utilities/utility.dart';


class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({required this.movie, Key? key}) : super(key: key);
  final TAG = "HomeScreen";
  final Movie movie;
  Stream<Movie> _watchFavMovieInDb(int serverId) {
    return Utility.database.watchMovieByIdInDb(serverId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: ColorValues.whiteColor,
          appBar: ReusableWidgets.appBarWidget(
              context: context,
              title: movie.originalTitle ?? "",
              showIcon: StreamBuilder(
                stream: _watchFavMovieInDb(movie.serverId ?? 0),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<dynamic> snapshot,
                    ) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return  ReusableWidgets.childButtonWidget(child: const Icon(Icons.favorite, color: ColorValues.mainColor,),
                          onButtonPress: (){
                            Utility.database.removeFromFavourite(movie.serverId ?? 0);
                          }, bgColor: ColorValues.whiteColor);
                    }
                    return ReusableWidgets.childButtonWidget(child: const Icon(Icons.favorite_border, color: ColorValues.mainColor,),
                        onButtonPress: (){
                          Utility.database.insertMovie(movie.toCompanion(true));
                        }, bgColor: ColorValues.whiteColor);
                  }
                  return ReusableWidgets.childButtonWidget(child: const Icon(Icons.favorite_border, color: ColorValues.mainColor,),
                      onButtonPress: (){
                        Utility.database.insertMovie(movie.toCompanion(true));
                      }, bgColor: ColorValues.whiteColor);
                  },
              ),
              onBackPress: (){Get.back();}
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: Pixels.screenPadding, right: Pixels.screenPadding),
            child: FutureBuilder<MovieDetailModel?>(
                future: Utility.apisRepo.fetchMovieDetail(movieId: movie.serverId ?? 0),
                builder: (ctx, AsyncSnapshot<MovieDetailModel?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Some Error',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      MovieDetailModel? movieDetailModel = snapshot.data;
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              // shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: 350,
                                  width: constraints.maxWidth/1.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: "${ApiConst.imageBaseUrl}${movieDetailModel?.posterPath ?? ""}",
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined, size: 40),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Pixels.labelToTextField,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconTheme(
                                      data: const IconThemeData(
                                        color: ColorValues.mainColor,
                                        size: 20,
                                      ),
                                      child: StarDisplay(
                                          value: (movieDetailModel?.voteAverage?? 2) ~/ 2
                                      ),
                                    ),
                                    ReusableWidgets.textWidget(
                                      text: " ${movieDetailModel?.voteAverage.toString()}/10",
                                      textColor: ColorValues.mainColor,
                                      fontSize: Pixels.smallTextSize,

                                    )
                                  ],
                                ),
                                const SizedBox(height: Pixels.large,),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ReusableWidgets.textWidget(text: "Overview",
                                      fontWeight: FontWeight.bold,
                                      textColor: ColorValues.darkTextColor, fontSize: Pixels.normalTextSize),
                                ),
                                const SizedBox(height: Pixels.large),

                                ReusableWidgets.textWidget(text: movieDetailModel?.overview ?? "",
                                    alignment: TextAlign.start,
                                    textColor: ColorValues.darkTextColor, fontSize: Pixels.smallTextSize,maxLine: 20),
                                const SizedBox(height: Pixels.large),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ReusableWidgets.textWidget(text: "Cast",
                                      fontWeight: FontWeight.bold,
                                      textColor: ColorValues.darkTextColor, fontSize: Pixels.normalTextSize),
                                ),
                                const SizedBox(height: Pixels.large),

                              SizedBox(height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: movieDetailModel?.credits?.cast?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return SizedBox(
                                      width: 160,
                                      height: 200,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 120,
                                                width: 120,
                                            child: CachedNetworkImage(
                                              imageUrl: '${ApiConst.imageBaseUrl}/${movieDetailModel?.credits?.cast?[index].profilePath}',
                                              imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined, size: 40),),
                                            ),
                                          const SizedBox(height: 15,),
                                          ReusableWidgets.textWidget(
                                              text: movieDetailModel?.credits?.cast?[index].originalName ?? "",
                                              textColor: ColorValues.darkTextColor, fontSize: Pixels.smallTextSize)
                                      ],),
                                    );
                                  },
                                ),
                              ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                  return ReusableWidgets.loadingWidget(text: "Please Wait", constraints: constraints);
                }),
          ),

        );
      },
    );
  }

}
