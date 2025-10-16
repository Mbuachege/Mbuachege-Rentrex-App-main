import 'package:get/get.dart';
import '../model/place_model.dart';
import '../util/asset_image_paths.dart';
import '../util/string_config.dart';

class HomeController extends GetxController {
  RxString appbarTitle = "".obs;
  RxList<bool> selectPopularItems = List.generate(5, (index) => false).obs;
  RxList<bool> selectedItems = List.generate(5, (index) => false).obs;
  RxList<bool> selectTripItems = List.generate(5, (index) => false).obs;

  RxList<PlaceModel> homeSecondList = [
    PlaceModel(
      text: StringConfig.northGoa,
      icon: AssetImagePaths.northGoaImage,
    ),
    PlaceModel(
      text: StringConfig.butterflyBeach,
      icon: AssetImagePaths.butterflyBeach,
    ),
    PlaceModel(
      text: StringConfig.kovaLamBeach,
      icon: AssetImagePaths.northGoaImage,
    ),
    PlaceModel(
      text: StringConfig.northGoa,
      icon: AssetImagePaths.butterflyBeach,
    ),
    PlaceModel(
      text: StringConfig.butterflyBeach,
      icon: AssetImagePaths.northGoaImage,
    ),
  ].obs;
  RxList<PlaceModel> internationalTripList = [
    PlaceModel(
      text: StringConfig.vietnam,
      icon: AssetImagePaths.vietnamImage,
    ),
    PlaceModel(
      text: StringConfig.hoChiMinhCity,
      icon: AssetImagePaths.hoChiMinhCityImage,
    ),
    PlaceModel(
      text: StringConfig.vietnam,
      icon: AssetImagePaths.vietnamImage,
    ),
    PlaceModel(
      text: StringConfig.hoChiMinhCity,
      icon: AssetImagePaths.hoChiMinhCityImage,
    ),
    PlaceModel(
      text: StringConfig.vietnam,
      icon: AssetImagePaths.vietnamImage,
    ),
  ].obs;

  RxList<PlaceModel> popularPlacesList = [
    PlaceModel(
      text: StringConfig.srinagar,
      icon: AssetImagePaths.srinagarImage,
    ),
    PlaceModel(
      text: StringConfig.manali,
      icon: AssetImagePaths.manaliImage,
    ),
    PlaceModel(
      text: StringConfig.darjeeling,
      icon: AssetImagePaths.darjeeling,
    ),
    PlaceModel(
      text: StringConfig.rishikesh,
      icon: AssetImagePaths.rishikeshImage,
    ),
    PlaceModel(
      text: StringConfig.srinagar,
      icon: AssetImagePaths.srinagarImage,
    ),
  ].obs;
}
