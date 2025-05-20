import 'package:can_i_ride_today/models/value_model.dart';
import 'package:can_i_ride_today/logic/weather_service.dart';
import 'package:flutter/material.dart';
//import 'package:collection/collection.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  String? selectedCity;
  bool _isLoading = false;
  List<ValueModel> values = [];

  Future<void> _searchWeather(csc.City city) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = WeatherService();
      final data = await service.fetchWeatherData(city);
      final temp =
          data['data_day']?['temperature_max']?[0]?.toString() ?? 'N/A';
      final windSpeed =
          data['data_day']?['windspeed_max']?[0]?.toString() ?? 'N/A';
      final rain =
          data['data_day']?['precipitation_probability']?[0]?.toString() ??
          'N/A';
      setState(() {
        log('setting state');
        values[0].value = '$temp °C';
        values[1].value = '$rain %';
        values[2].value = '$windSpeed km/h';
      });
    } catch (e) {
      log('_searchWeather catch block');
      setState(() {});
    } finally {
      log('_searchWeather finally block');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    values = ValueModel.getValues(); // ← nur einmal beim Start!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          SizedBox(height: 20),
          if (_isLoading) CircularProgressIndicator(),
          _valuesSection(),
        ],
      ),
    );
  }

  Column _valuesSection() {
    for (var value in values) {
      log('value: ${value.value}');
    }
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Wetterdaten',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 200,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: ListView.separated(
              itemCount: values.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(width: 20),
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: values[index].boxColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          values[index].icon,
                          size: 40,
                          color: values[index].boxColor,
                        ),
                      ),
                      Text(values[index].name),
                      SizedBox(height: 10),
                      Text(
                        values[index].value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: FutureBuilder<List<csc.City>>(
        future: csc.getCountryCities('DE'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Fehler: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Keine Städte gefunden');
          } else {
            final cities = snapshot.data!;
            return Autocomplete<csc.City>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<csc.City>.empty();
                }
                return cities.where(
                  (c) => c.name.toLowerCase().startsWith(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              displayStringForOption: (csc.City city) => city.name,
              onSelected: (csc.City city) {
                setState(() {
                  selectedCity = city.name;
                  _controller.text = city.name;
                  _searchWeather(city);
                });
              },
              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Stadt',
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Can I Ride Today?'),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          log('pressedBack'); // Handle back action
        },
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.arrow_back),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            log('pressedMenu'); // Besseres Logging
          },
          child: Container(
            margin: EdgeInsets.all(10),
            width: 37,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}
