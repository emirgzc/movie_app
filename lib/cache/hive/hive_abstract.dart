import 'package:movie_app/models/detail_movie.dart';

abstract class HiveAbstract<T> {
  Future<void> add({required T detail});
  T? get({required int id});
  List<T> getAll();
  Future<bool> delete({required T detail});
}
