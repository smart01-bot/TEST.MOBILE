import 'package:flutter/material.dart';

import 'colors.dart';

ButtonStyle mainButtonStyle = ButtonStyle(
  elevation: WidgetStateProperty.all(0),
  minimumSize: WidgetStateProperty.all(
    Size(100, 45),
  ),
  maximumSize: WidgetStateProperty.all(
    Size(double.infinity, 45),
  ),
  backgroundColor: WidgetStatePropertyAll(CIColors.primaryColor),
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
