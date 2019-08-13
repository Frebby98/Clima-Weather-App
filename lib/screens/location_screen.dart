import 'dart:convert';

import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'city_screen.dart';
import 'loading_screen.dart';

class LocationScreen extends StatefulWidget {
  final String temp;
  final String weatherIcon;
  final String message;
  final String cityName;
  LocationScreen({@required this.temp, this.weatherIcon, this.message, this.cityName});
  @override
  _LocationScreenState createState() => _LocationScreenState(this.temp, this.weatherIcon,
  this.message, this.cityName);
}

class _LocationScreenState extends State<LocationScreen> {
  String temp;
  String weatherIcon, message, cityName;
  static var push;
  NetworkHelper networkHelper = NetworkHelper();
WeatherModel weatherModel = WeatherModel();
  var weather;
  var getTemp;
  var getDescription;
  var url = '$kOpenWeatherMapEndPoint''q=$push&APPID=$kApiKey&units=metric';

  Future getUrl() async {
    if (push != null) {
      var response = await networkHelper.getUrl(url);
checkResponse(response);
      print(url);
      print(response.body);
      print(push);
    } else {
      print('Not seen yet');
    }
  }
    void checkResponse(Response response) async {
      if (response.statusCode == 200) {

        getTemp = jsonDecode(response.body)['main']['temp'];
        weather = jsonDecode(response.body)['weather'][0]['id'];
        weatherIcon = weatherModel.getWeatherIcon(weather);
        getDescription = weatherModel.getMessage(getTemp);
        cityName = jsonDecode(response.body)['name'];
       this.temp = getTemp.toString();
//       var weatherIcons = this.weatherIcon == weatherIcon;
//       var citynames = this.cityName = cityName;
this.message = getDescription.toString();
        var locationScreen = LocationScreen(temp: temp.toString(), weatherIcon: weatherIcon, cityName: cityName, message: getDescription,);
        print(temp);
        print(weatherIcon);
        print(getDescription);
        print(cityName);
        print(locationScreen);

      }else {
        print("Request failed with status: ${response.statusCode}.");
      }
  }

  _LocationScreenState(this.temp, this.weatherIcon, this.message, this.cityName);
LoadingScreen loadingScreen = LoadingScreen();

  @override
  Widget build(BuildContext context) {
    setState(() {
      getUrl();
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      setState(() {
    });
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed:() async {
                       push = await Navigator.push(context, MaterialPageRoute(builder: (context)
                      => CityScreen()
                      )
                      );
                       if(push != null){
                         setState(() {
                           getUrl();

                         });
                       }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
//                      '°',
                    '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
//                      '☀️',
                    weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$message in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
