import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2280),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie App',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Style.whiteColor,
            ),
            scaffoldBackgroundColor: Style.whiteColor,
          ),
          onGenerateRoute: RouteGenerator.routeGenrator,
        );
      },
    );
  }
}
