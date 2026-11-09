import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/overlay_controller.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OverlayProvider>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: controller.isShownLoadingOverlay,
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
                  color: const Color.fromARGB(49, 239, 244, 252),
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(118, 255, 255, 255),
                        border: Border.all(
                          color: const Color.fromARGB(14, 71, 104, 139),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CIColors.accentColor,
                          ),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ), // Needed for blur to work
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
