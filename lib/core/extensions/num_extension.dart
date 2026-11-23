import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NumExtension on num {
  Widget get heightBox => SizedBox(height: toDouble());
  Widget get widthBox => SizedBox(width: toDouble());

  EdgeInsets get allPadding => EdgeInsets.all(toDouble());
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  BorderRadius get circularRadius => BorderRadius.circular(toDouble());
  Radius get radius => Radius.circular(toDouble());

  String get formattedCurrency => NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: toDouble() % 1 == 0 ? 0 : 2,
  ).format(toDouble());
}
