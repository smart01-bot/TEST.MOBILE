import 'package:test_mobile/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

MarkdownStyleSheet getCustomMarkdownStyle(BuildContext context) {
  const customFont = 'Inter';

  return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
    a: const TextStyle(
      color: CIColors.secondaryColor,
      decoration: TextDecoration.underline,
      decorationColor: CIColors.secondaryColor,
      fontWeight: FontWeight.bold,
      fontFamily: customFont,
    ),
    p: const TextStyle(
      fontFamily: customFont,
      fontSize: 14,
      height: 1.6, // line spacing
    ),
    pPadding: const EdgeInsets.only(bottom: 16.0),

    h2Padding: const EdgeInsets.only(top: 8.0, bottom: 0),
    h3Padding: const EdgeInsets.only(top: 8.0, bottom: 0),

    h1: const TextStyle(
      fontFamily: customFont,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      height: 1.2,
      color: CIColors.textColor,
    ),
    h2: const TextStyle(
      fontFamily: customFont,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      height: 1.2,
      color: CIColors.textColor,
    ),
    h3: const TextStyle(
      fontFamily: customFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: CIColors.textColor,
    ),
    // Optional: list bullets, code, blockquote, etc.
  );
}
