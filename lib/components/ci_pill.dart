import 'package:flutter/material.dart';

class CiPill extends StatelessWidget {
  final String label;
  final String colorTheme;
  final bool bolder;

  CiPill(
    this.label, {
    this.colorTheme = "default",
    this.bolder = true,
    super.key,
  });

  final Map<String, dynamic> colorThemes = {
    "default": {
      "text": Color(0xff777a8b),
      "background": Color(0xffefefef),
      "border": Color(0xffb1b1b1),
    },
    "success": {
      "text": Color(0xff229727),
      "background": Color(0xffdbf3de),
      "border": Color(0xff208516),
    },
    "rejected": {
      "text": Color(0xffad6161),
      "background": Color(0xfffff4f4),
      "border": Color(0xffce736b),
    },
    "blue": {
      "text": Color(0xff2878D0),
      "background": Color(0xffE8F0FA),
      "border": Color(0xff2878D0),
    },
    "yellow-green": {
      "text": Color(0xff70962e),
      "background": Color(0xffeffadb),
      "border": Color(0xffa0d04e),
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: colorThemes[colorTheme]!['background'],
        borderRadius: BorderRadius.circular(20),
        border: bolder
            ? Border.all(
                color: colorThemes[colorTheme]!['border'],
                width: 1,
              )
            : null,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorThemes[colorTheme]!['text'],
          fontSize: 12,
          fontWeight: bolder ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
