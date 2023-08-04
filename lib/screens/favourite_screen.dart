import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../database_drift/database.dart';
import '../dio_apis/api_const.dart';
import '../utilities/color_values.dart';
import '../utilities/pixels.dart';
import '../utilities/reusable_widgets.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import 'movie_detail_screen.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  Stream<List<Movie>> _watchMoviesInDb() {
    return Utility.database.watchMoviesInDb();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: ColorValues.whiteColor,
          appBar: ReusableWidgets.appBarWidget(
              context: context,
              title: "Favorites",
              isBottomNavScreen: true,
              onBackPress: () {}),
          body: Padding(
            padding: const EdgeInsets.only(
                left: Pixels.screenPadding, right: Pixels.screenPadding),
            child: StreamBuilder(
              stream: _watchMoviesInDb(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Movie>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      color: ColorValues.whiteColor,
                      child: const Center(child: CircularProgressIndicator()));
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return ReusableWidgets.textWidget(
                        text: "No data found",
                        textColor: ColorValues.darkTextColor,
                        fontSize: Pixels.smallTextSize);
                  } else if (snapshot.hasData) {
                    List<Movie>? movies = snapshot.data;
                    if (movies != null) {
                      log("Data from DB: $movies");
                      return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 230,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2),
                          itemCount: movies.length,
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(() => MovieDetailScreen(movie: movies[index],));
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 180,
                                    width: (constraints.maxWidth - (20 + 2 * (Pixels.screenPadding))) / 2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: "${ApiConst.imageBaseUrl}${movies[index].posterPath ?? ""}",
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined, size: 40),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Pixels.labelToTextField,
                                  ),
                                  ReusableWidgets.textWidget(
                                      text: movies[index].originalTitle ?? "",
                                      textColor: ColorValues.darkTextColor,
                                      fontSize: Pixels.smallTextSize,
                                      maxLine: 2),
                                ],
                              ),
                            );
                          });
                    }
                    return ReusableWidgets.textWidget(
                        text: "No data found",
                        textColor: ColorValues.darkTextColor,
                        fontSize: Pixels.smallTextSize);
                  } else {
                    return ReusableWidgets.textWidget(
                        text: "No data found",
                        textColor: ColorValues.darkTextColor,
                        fontSize: Pixels.smallTextSize);
                  }
                } else {
                  return Center(
                    child: Card(
                      child: Text('State: ${snapshot.connectionState}'),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
