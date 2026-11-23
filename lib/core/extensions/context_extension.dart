import 'package:flutter/material.dart';
import 'package:nishit_vadgama/generated/l10n.dart';

/// Extension on [BuildContext] for ColorScheme, localization, and UI utilities.
extension ContextExtension on BuildContext {
  // ColorScheme accessor
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Localization accessors
  S get l10n => S.of(this);
  S get strings => S.of(this);

  // Unfocus keyboard
  void hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
