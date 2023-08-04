import 'package:get/get.dart';
import 'package:movies_app/database_drift/database.dart';


class BtmNavBarController extends GetxController {

  var selectedTab = 0.obs;

  var sortingPreference = "popularity".obs;

  var movieStream = <Movie>[].obs;

}