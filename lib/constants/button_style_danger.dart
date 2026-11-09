import 'package:flutter/material.dart';

import 'colors.dart';

ButtonStyle dangerButtonStyle = ButtonStyle(
  elevation: WidgetStateProperty.all(0),
  minimumSize: WidgetStateProperty.all(
    Size(90, 45),
  ),
  maximumSize: WidgetStateProperty.all(
    Size(double.infinity, 45),
  ),
  backgroundColor: WidgetStatePropertyAll(CIColors.errorColor),
  padding: WidgetStatePropertyAll(
    EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 0,
    ),
  ),
  tapTargetSize:
      MaterialTapTargetSize.shrinkWrap, // 👈 This removes extra margin
  visualDensity: VisualDensity.compact,
);
