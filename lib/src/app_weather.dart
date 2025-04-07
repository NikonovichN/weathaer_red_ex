import 'package:flutter/material.dart';

import 'features/home/home_page.dart';

class AppWeather extends StatelessWidget {
  const AppWeather({super.key});

  static const _appTitle = 'Weather Forecast';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: HomePage(title: Text(_appTitle)),
    );
  }
}
