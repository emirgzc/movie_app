enum MediaTypes {
  movie,
  tv,
  person,
}

enum HiveEnums{
  movies,
  tv,
}

enum NavigatorType {
  movieDetailPage,
  tvDetailPage,
}

extension NavigatorTypeExtension on NavigatorType {
  String _name() {
    switch (this) {
      case NavigatorType.movieDetailPage:
        return '/movieDetailPage';
      case NavigatorType.tvDetailPage:
        return '/tvDetailPage';
    }
  }

  String get nameGet => _name();
}

enum ListType {
  popular_movies,
  top_rated_movies,
  upcoming_movies,
  movies_in_cinemas,
  trend_movies,
  top_rated_series,
  popular_series,
  series_on_air,
  trending_series_of_the_week,
}

enum LanguageCodes {
  en,
  tr,
}

enum MovieApiType {
  popular,
  top_rated,
  upcoming,
  now_playing,
  trending,
  on_the_air,
}

enum LocationErrors {
  locationServicesAreDisabled,
  locationPermissionsAreDenied,
  locationPermissionsArepermanentlyDenied,
}

enum LogoPath {
  png_logo_2_day,
  png_logo_2_dark,
  png_logo_1_day,
  png_logo_1_dark,
  logo_png,
  light_lg1_removebg,
}

enum IconPath {
  arrow_left,
  arrow_right_short,
  arrow_right,
  camera,
  comment_card,
  comment,
  favorite_fill,
  favorite,
  file,
  film,
  location,
  info,
  menu_list,
  play,
  plus_lg,
  plus_square,
  plus,
  search,
  settings,
  share,
  star,
  star_fill,
  times,
  trash,
  tv,
  users,
}
