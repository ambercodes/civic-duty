class Formatters {
  const Formatters._();

  static String compactNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }

  static String percent(double value) {
    return '${value.toStringAsFixed(2)}%';
  }
}
