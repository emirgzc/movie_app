abstract class HiveAbstract<T> {
  Future<void> add({required T detail});
  T? get({required int id});
  Future<List<T>> getAll();
  Future<bool> delete({required T detail});
}
