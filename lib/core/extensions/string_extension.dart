import 'package:get/get.dart';

/// Extension on [String] for validation, formatting, and localization shortcuts.
extension StringExtension on String {
  // Localization shorthand wrapper (delegates cleanly to GetX .tr)
  String get trLocal => tr;

  // Validation
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(trim());
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    return length >= 8 && phoneRegex.hasMatch(trim());
  }

  bool get isStrongPassword {
    // At least 8 chars, 1 letter, 1 number
    return length >= 8 &&
        contains(RegExp(r'[A-Za-z]')) &&
        contains(RegExp(r'[0-9]'));
  }

  bool get isNumeric {
    return double.tryParse(trim()) != null;
  }

  // Formatting & Capitalization
  String get capitalizeFirstLetter {
    if (trim().isEmpty) return this;
    final clean = trim();
    return clean[0].toUpperCase() + clean.substring(1);
  }

  String get toTitleCase {
    if (trim().isEmpty) return this;
    return split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }
}

/// Extension on nullable [String] for safe defaults.
extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String orDefault([String defaultValue = '']) =>
      isNullOrEmpty ? defaultValue : this!;
}
