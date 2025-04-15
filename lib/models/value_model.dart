import 'package:flutter/material.dart';

class ValueModel {
  String name;
  String value;
  IconData? icon;
  Color boxColor;

  ValueModel({
    required this.name,
    required this.value,
    required this.boxColor,
    required this.icon,
  });

  static List<ValueModel> getValues() {
    List<ValueModel> values = [];

    values.add(
      ValueModel(
        name: 'Temperatur',
        value: 'N/A',
        boxColor: Colors.blue,
        icon: Icons.thermostat,
      ),
    );
    values.add(
      ValueModel(
        name: 'Regen',
        value: 'N/A',
        boxColor: Colors.orange,
        icon: Icons.water_drop,
      ),
    );
    values.add(
      ValueModel(
        name: 'Windgeschwindigkeit',
        value: 'N/A',
        boxColor: Colors.red,
        icon: Icons.wind_power,
      ),
    );
    return values;
  }
}
