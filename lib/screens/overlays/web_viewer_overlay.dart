import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/overlay_controller.dart';

/// External web content is intentionally disabled in standalone TEST.
class WebViewerOverlay extends StatelessWidget {
  const WebViewerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final overlayController = Provider.of<OverlayProvider>(context);
    return ValueListenableBuilder<bool>(
      valueListenable: overlayController.isShownWebViewerOverlay,
      builder: (context, isVisible, _) {
        if (!isVisible) return const SizedBox.shrink();
        return Positioned.fill(
          child: Material(
            color: CIColors.canvasBGColor,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          overlayController.webViewerName,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: CIColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          overlayController.hideWebViewerOverlay();
                          overlayController.webViewerName = '';
                          overlayController.webViewerLink = '';
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: CIColors.primaryColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'External web pages are disabled in this offline demo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: CIColors.textColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}