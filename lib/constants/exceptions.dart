class ApiExceptions implements Exception {
  String title;
  ApiExceptions(this.title);

  @override
  String toString() {
    return 'Exception for $title';
  }
}
