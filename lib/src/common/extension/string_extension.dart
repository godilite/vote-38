import 'dart:convert';
import 'dart:typed_data';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toDateString() {
    final parsedDate = DateTime.parse(this);
    final formattedDate = '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    return formattedDate;
  }

  String truncate(int maxLength) {
    if (length <= maxLength) {
      return this;
    }

    final mid = maxLength ~/ 2;
    final end = length - mid;
    return '${substring(0, mid)}...${substring(end)}';
  }
}

extension Uint8ListExtension on Uint8List {
  String toDecodedString() {
    return utf8.decode(this);
  }
}
