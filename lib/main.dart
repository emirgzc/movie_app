import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/pages/movie_detail_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MovieDetailPage(),
    );
  }
}
