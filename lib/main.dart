import 'package:flutter/material.dart';
import 'package:neurotask/theme.dart';
import 'pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // for larger apps i'd use page routes here
      debugShowCheckedModeBanner: false,
      title: 'Neurolief App',
      theme: buildTheme(),
      home: const Home(title: 'Neurolief'),
    );
  }
}
