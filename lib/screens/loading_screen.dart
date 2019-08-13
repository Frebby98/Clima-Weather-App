import 'package:clima/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:http/http.dart';
import 'location_screen.dart';
class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var url = '$kOpenWeatherMapEndPoint''q=uyo,nigeria&APPID=$kApiKey&units=metric';
  double temp;
  String weatherIcon;
  int weather;
  String getDescription;
  String cityName;
  WeatherModel weatherModel = WeatherModel();
  NetworkHelper networkHelper = NetworkHelper();

  void getUrl() async {
    var response = await networkHelper.getUrl(url);
    checkResponse(response);
  }

void checkResponse(Response response) async {
  if (response.statusCode == 200) {
    temp = convert.jsonDecode(response.body)['main']['temp'];
    weather = convert.jsonDecode(response.body)['weather'][0]['id'];
    weatherIcon = weatherModel.getWeatherIcon(weather);
     getDescription = weatherModel.getMessage(temp.toInt());
     cityName = convert.jsonDecode(response.body)['name'];
    print(temp);
    print(weatherIcon);
    print(getDescription);
    print(cityName);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationScreen(temp: temp.toString(),
          weatherIcon: weatherIcon.toString(),
          message: getDescription,
          cityName: cityName,),
        ));
  }else {
    print("Request failed with status: ${response.statusCode}.");
  }

}

  @override
  void initState() {
    getUrl();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(

      ),
    );
  }
}
