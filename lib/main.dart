import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/locator.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/route_generator.dart';
import 'package:movie_app/theme/theme_dark.dart';
import 'package:movie_app/theme/theme_data_provider.dart';
import 'package:movie_app/theme/theme_light.dart';
import 'package:movie_app/translations/codegen_loader.g.dart';
import 'package:provider/provider.dart';

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DetailMovieAdapter());
  await Hive.openBox<DetailMovie>('movies');
  Hive.registerAdapter(TvDetailAdapter());
  await Hive.openBox<TvDetail>('tv');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await setupHive();
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeDataProvider(),
      child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('tr')],
        path: 'assets/translations',
        useOnlyLangCode: true,
        fallbackLocale: Locale('tr'),
        assetLoader: CodegenLoader(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeDataProvider _provider = Provider.of<ThemeDataProvider>(context);
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(1080, 2280),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'Movie Go',
          theme: LightTheme().lightTheme,
          darkTheme: DarkTheme().darkTheme,
          themeMode: _provider.brightness == null
              ? ThemeMode.system
              : _provider.brightness == Brightness.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
          onGenerateRoute: RouteGenerator.routeGenrator,
        );
      },
    );
  }
}
