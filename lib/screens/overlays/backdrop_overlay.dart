import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/overlay_controller.dart';

class BackdropOverlay extends StatelessWidget {
  const BackdropOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OverlayProvider>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: controller.isShownDrawerOverlay,
      builder: (context, isVisible, _) {
        if (!isVisible) return SizedBox.shrink();

        return Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: const Color.fromARGB(
                      49, 239, 244, 252), // Needed for blur to work
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
