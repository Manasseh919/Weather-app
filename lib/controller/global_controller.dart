import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weatherapp_starter_project/api/fetch_weather.dart';
import 'package:weatherapp_starter_project/model/weather_data.dart';

class GlobalController extends GetxController {
  //create various variables
  final RxBool _isLoading = true.obs;
  final RxDouble _lattitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
    final RxInt _currentIndex = 0.obs;

  //instance for them to be called
  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => _lattitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;
  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    if (_isLoading.isTrue) {
      getLocation();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    //return if service is not enabled
    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }
    //status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permisiion are denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      //      request Permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Permission is denied");
      }
    }
    //    getting current position
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .then((value) {
      //update latitude and longitude
      _lattitude.value = value.latitude;
      _longitude.value = value.longitude;
      // _isLoading.value = false;

      return FetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
      });
    });
  }
   RxInt getIndex() {
    return _currentIndex;
  }
}
