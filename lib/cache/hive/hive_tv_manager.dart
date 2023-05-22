import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/cache/hive/hive_abstract.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/models/detail_tv.dart';

class HiveTvManager extends HiveAbstract<TvDetail> {
  late Box<TvDetail> _tvBox;

  HiveTvManager() {
    _tvBox = Hive.box<TvDetail>(HiveEnums.tv.name);
  }

  @override
  Future<void> add({required TvDetail detail}) async {
    await _tvBox.put(detail.id, detail);
  }

  @override
  Future<bool> delete({required TvDetail detail}) async {
    await detail.delete();
    return true;
  }

  @override
  List<TvDetail> getAll()  {
    List<TvDetail> _allTv = <TvDetail>[];
    _allTv = _tvBox.values.toList();
    if (_allTv.isNotEmpty) {
      _allTv.sort(
        (TvDetail a, TvDetail b) => b.firstAirDate?.compareTo(a.firstAirDate ?? DateTime.now()) ?? 0,
      );
    }
    return _allTv;
  }

  @override
  TvDetail? get({required int id}) {
    if (_tvBox.containsKey(id)) {
      return _tvBox.get(id);
    } else {
      return null;
    }
  }
}
