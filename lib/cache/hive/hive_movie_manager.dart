import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/cache/hive/hive_abstract.dart';
import 'package:movie_app/models/detail_movie.dart';

class HiveMovieManager extends HiveAbstract<DetailMovie> {
  late Box<DetailMovie> _movieBox;

  HiveMovieManager() {
    _movieBox = Hive.box<DetailMovie>('movies');
    //_movieBox.clear();
  }

  @override
  Future<void> add({required DetailMovie detail}) async {
    await _movieBox.put(detail.id, detail);
  }

  @override
  Future<bool> delete({required DetailMovie detail}) async {
    await detail.delete();
    return true;
  }

  @override
  Future<List<DetailMovie>> getAll() async {
    List<DetailMovie> _allMovie = <DetailMovie>[];
    _allMovie = _movieBox.values.toList();
    if (_allMovie.isNotEmpty) {
      _allMovie.sort(
        (DetailMovie a, DetailMovie b) => b.releaseDate?.compareTo(a.releaseDate ?? DateTime.now()) ?? 0,
      );
    }
    return _allMovie;
  }

  @override
  DetailMovie? get({required int id}) {
    if (_movieBox.containsKey(id)) {
      return _movieBox.get(id);
    } else {
      return null;
    }
  }
}
