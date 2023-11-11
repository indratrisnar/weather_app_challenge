extension StringExtensions on String {
  String get capital => this[0].toUpperCase() + substring(1);
  String get capitalEachWord =>
      split(' ').map((word) => word.capital).join(' ');
}
