import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  final _cityController = TextEditingController();

  Future<void> _fetchWeather() async {
    setState(() => _isLoading = true);

    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2:8000/api/weather/?city=${_cityController.text}',
      ),
    );

    if (response.statusCode == 200) {
      setState(() => _weatherData = json.decode(response.body));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Column(
        children: [
          TextField(controller: _cityController),
          ElevatedButton(onPressed: _fetchWeather, child: Text('Get Weather')),
          if (_isLoading) ...[
            CircularProgressIndicator(),
          ] else if (_weatherData != null) ...[
            Text(
              '${_weatherData!['current']['temp']}°C',
              style: TextStyle(fontSize: 40),
            ),
            Image.network(
              'https://openweathermap.org/img/wn/${_weatherData!['current']['icon']}@2x.png',
            ),
            // Add forecast ListView.builder here
          ],
        ],
      ),
    );
  }
}
