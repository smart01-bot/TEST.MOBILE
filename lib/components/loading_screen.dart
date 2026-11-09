import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LoadingScreen extends StatelessWidget {
  final String description;
  const LoadingScreen({this.description = "Loading...", super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CIColors.accentColor,
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            textAlign: TextAlign.center,
            description,
            style: TextStyle(
              color: CIColors.accentColor,
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
