import 'package:get_it/get_it.dart';
import 'package:movie_app/cache/hive/hive_abstract.dart';
import 'package:movie_app/cache/hive/hive_movie_manager.dart';
import 'package:movie_app/cache/hive/hive_tv_manager.dart';
import 'package:movie_app/cache/shared_manager.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/detail_tv.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<HiveAbstract<DetailMovie>>(HiveMovieManager());
  locator.registerSingleton<HiveAbstract<TvDetail>>(HiveTvManager());
  locator.registerSingleton<SharedAbstract>(SharedManager());
}
