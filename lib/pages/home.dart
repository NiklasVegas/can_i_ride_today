import 'package:can_i_ride_today/models/value_model.dart';
import 'package:can_i_ride_today/logic/weather_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _result;
  List<ValueModel> values = [];

  Future<void> _searchWeather() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });
    try {
      final service = WeatherService();
      final data = await service.fetchWeatherData(_controller.text);
      final temp =
          data['data_day']?['temperature_max']?[0]?.toString() ?? 'N/A';
      setState(() {
        _result = 'Maximale Temperatur: $temp °C';
      });
    } catch (e) {
      setState(() {
        _result = 'Fehler: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getValues() {
    values = ValueModel.getValues();
  }

  @override
  Widget build(BuildContext context) {
    _getValues();
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          SizedBox(height: 100),
          if (_isLoading)
            CircularProgressIndicator()
          else if (_result != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(_result!, style: TextStyle(fontSize: 18)),
            ),
          _valuesSection(),
        ],
      ),
    );
  }

  Column _valuesSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Wetterdaten',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 200,
          color: Colors.green,
          child: ListView.separated(
            itemCount: values.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 20),
            itemBuilder: (context, index) {
              return Container(
                width: 150,
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
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          hintText: 'Gib deine Stadt ein',
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          hintStyle: TextStyle(color: Colors.black),
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(Icons.search),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              _searchWeather();
            },
            icon: Icon(Icons.search),
          ),
        ),
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
