
import 'package:card_informatics_mobile_app/screens/enter_passcode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/overlay_controller.dart';

class AppLockOverlay extends StatelessWidget {
  const AppLockOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OverlayProvider>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: controller.isShownAppLockOverlay,
      builder: (context, isVisible, _) {
        if (!isVisible) return SizedBox.shrink();

        return Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: EnterPasscodeScreen(),
          ),
        );
      },
    );
  }
}
