/*
Used in field labels to convert label words to separate Text() 
widgets to allow good wrap behaviour which saves space
*/

import 'package:flutter/material.dart';

import '../constants/colors.dart';

List<Widget> sentenceToTextWidgets(
  String sentence, {
  Color color = CIColors.accentColor,
}) {
  // Split the sentence into words, and remove any empty strings (from extra spaces)
  List<String> words =
      sentence.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

  // Convert the list of words into a list of Text widgets
  return words
      .map((word) => Text(
            "$word ",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ))
      .toList();
}
