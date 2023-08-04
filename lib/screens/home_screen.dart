import 'package:cached_network_image/cached_network_image.dart';
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
              showIcon: ReusableWidgets.childButtonWidget(
                  onButtonPress: () {
                    Get.to(() => SettingsScreen());
                  },
                  child: const Icon(
                    Icons.settings,
                    color: ColorValues.mainColor,
                  ),
                  bgColor: ColorValues.whiteColor),
              onBackPress: () {
                Get.back();
              }),
          body: Padding(
            padding: const EdgeInsets.only(
                left: Pixels.screenPadding, right: Pixels.screenPadding),
            child: FutureBuilder<List<Movie>?>(
                future: Utility.apisRepo.fetchMovies(),
                builder: (ctx, AsyncSnapshot<List<Movie>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Some error accrued check your internet connection please.',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<Movie>? movies = snapshot.data;

                      if (movies != null) {
                        Utility.btmNavBarController.movieStream.value = movies;
                        Utility.sortMovies();
                      }
                      return Obx(
                        () => ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              Utility.btmNavBarController.movieStream.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (Utility.btmNavBarController.movieStream.isNotEmpty) {
                                  Get.to(() => MovieDetailScreen(movie: Utility.btmNavBarController.movieStream[index],
                                  ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: 200,
                                        width: 130,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${ApiConst.imageBaseUrl}${Utility.btmNavBarController.movieStream[index].posterPath ?? ""}",
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined, size: 40),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth -
                                          (140 + (2 * Pixels.screenPadding)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ReusableWidgets.textWidget(
                                              text: Utility.btmNavBarController.movieStream[index].originalTitle ?? "",
                                              textColor: ColorValues.darkTextColor,
                                              fontSize: Pixels.smallTextSize,
                                              maxLine: 1),
                                          const SizedBox(
                                            height: Pixels.labelToTextField,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconTheme(
                                                data: const IconThemeData(
                                                  color: ColorValues.mainColor,
                                                  size: 20,
                                                ),
                                                child: StarDisplay(
                                                    value: (movies?[index].voteAverage ?? 2) ~/ 2),
                                              ),
                                              ReusableWidgets.textWidget(
                                                text: " ${Utility.btmNavBarController.movieStream[index].voteAverage.toString()}/10",
                                                textColor: ColorValues.mainColor,
                                                fontSize: Pixels.smallTextSize,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: Pixels.labelToTextField,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ReusableWidgets.textWidget(
                                                text: "Popular",
                                                textColor: ColorValues.mainColor,
                                                fontSize: Pixels.smallTextSize,
                                              ),
                                              ReusableWidgets.textWidget(
                                                text: " ${Utility.btmNavBarController.movieStream[index].popularity.toString()}",
                                                textColor: ColorValues.mainColor,
                                                fontSize: Pixels.smallTextSize,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: Pixels.labelToTextField,
                                          ),
                                          ReusableWidgets.textWidget(
                                              text: movies?[index].releaseDate ?? "",
                                              textColor: ColorValues.darkTextColor,
                                              fontSize: Pixels.smallTextSize,
                                              maxLine: 1),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                  return ReusableWidgets.loadingWidget(
                      text: "Please Wait", constraints: constraints);
                }),
          ),
        );
      },
    );
  }

}
