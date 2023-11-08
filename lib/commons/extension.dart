extension StringExtensions on String {
  String get capital => this[0].toUpperCase() + substring(1);
  String get capitalize => split(' ').map((word) => word.capital).join(' ');
}
