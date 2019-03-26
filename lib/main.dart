import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'airtable-game.dart';

main() async {
  await Flame.init(orientation: DeviceOrientation.portraitUp);
  runApp(new AirtableGame().widget);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        showPerformanceOverlay: true,
        title: 'My Awesome App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new AirtableGame().widget);
  }
}
