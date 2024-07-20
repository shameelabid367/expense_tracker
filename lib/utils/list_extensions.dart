// list_extensions.dart

extension ListGetOrDefault<T> on List<T> {
  T getOrDefault(int index, T defaultValue) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return defaultValue;
  }
}
