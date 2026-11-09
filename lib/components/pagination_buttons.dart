import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';

class PaginationButtons extends StatelessWidget {
  final Function func;
  final bool showNext;
  final bool showPrev;

  const PaginationButtons({
    super.key,
    required this.func,
    this.showNext = false,
    this.showPrev = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (showPrev)
              GestureDetector(
                onTap: () {
                  func(false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(104, 57, 171, 209),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.chevronLeft,
                        size: 12,
                        color: CIColors.textColor,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Prev',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (showNext)
              GestureDetector(
                onTap: () {
                  func(true);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(104, 57, 171, 209),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: 12,
                        color: CIColors.textColor,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
