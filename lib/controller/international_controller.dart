import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../model/place_model.dart';
import '../util/asset_image_paths.dart';
import '../util/string_config.dart';

class InternationalController extends GetxController {
  RxList<bool> tripSelectItems = List.generate(8, (index) => false).obs;
  RxList<bool> popularPlacesIndex = List.generate(8, (index) => false).obs;
  RxList<bool> internationalTripIndex = List.generate(5, (index) => false).obs;

  RxList<PlaceModel> internationalList = [
    PlaceModel(
      text: StringConfig.vietnam,
      icon: AssetImagePaths.lockingImage,
    ),
    PlaceModel(
      text: StringConfig.hoChiMinhCity,
      icon: AssetImagePaths.montereyImage,
    ),
    PlaceModel(
      text: StringConfig.sanFranciso,
      icon: AssetImagePaths.sanFrancisImage,
    ),
    PlaceModel(
      text: StringConfig.monterey,
      icon: AssetImagePaths.montereyImage,
    ),
    PlaceModel(
      text: StringConfig.hogsFeet,
      icon: AssetImagePaths.hogsFeetImage,
    ),
    PlaceModel(
      text: StringConfig.lockinge,
      icon: AssetImagePaths.lockingImage,
    ),
    PlaceModel(
      text: StringConfig.chester,
      icon: AssetImagePaths.chesterImage,
    ),
    PlaceModel(
      text: StringConfig.lockinge,
      icon: AssetImagePaths.lockingImage,
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
      icon: AssetImagePaths.srinagar2,
    ),
    PlaceModel(
      text: StringConfig.rishikesh,
      icon: AssetImagePaths.rishikesh2,
    ),
    PlaceModel(
      text: StringConfig.mussoorie,
      icon: AssetImagePaths.srinagarImage,
    ),
    PlaceModel(
      text: StringConfig.yamunotri,
      icon: AssetImagePaths.manaliImage,
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
      text: StringConfig.losAngeles,
      icon: AssetImagePaths.losAngelesImage,
    ),
    PlaceModel(
      text: StringConfig.hogsFeet,
      icon: AssetImagePaths.hogsFeetImage,
    ),
    PlaceModel(
      text: StringConfig.monterey,
      icon: AssetImagePaths.montereyImage,
    ),
  ].obs;
}
