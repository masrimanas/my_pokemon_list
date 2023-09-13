extension StringExtension on String {
  String get hardcode => this;

  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';

  String get capitalizeAll => split(' ').map((e) => e.capitalize).join(' ');
}
