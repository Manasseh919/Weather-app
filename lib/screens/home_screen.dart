import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp_starter_project/controller/global_controller.dart';
import 'package:weatherapp_starter_project/widgets/current_weather_widget.dart';
import 'package:weatherapp_starter_project/widgets/daily_data_forecast.dart';
import 'package:weatherapp_starter_project/widgets/header_widget.dart';
import 'package:weatherapp_starter_project/widgets/hourly_data_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //call
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child:
          //type of value
          Obx(
        ((() => globalController.checkLoading().isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const HeaderWidget(),
                    //for the current temperature
                    CurrentWeatherWidget(
                      weatherDataCurrent:
                          globalController.getData().getCurrentWeather(),
                    ),
                    HourlyDataWidget(
                      weatherDataHourly:
                          globalController.getData().getHourlyWeather(),
                    ),
                    DailyDataForecast(
                      weatherDataDaily:
                          globalController.getData().getDailyWeather(),
                    ),
                  ],
                ),
              ))
              ),
      ),
    ));
  }
}
