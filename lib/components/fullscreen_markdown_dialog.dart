import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';

/// Displays a local notice instead of fetching remote Card Informatics content.
class FullScreenMarkdownDialog extends StatelessWidget {
  final String title;
  // Retained for compatibility; this URL is intentionally never opened/fetched.
  final String markdownUrl;

  const FullScreenMarkdownDialog({
    super.key,
    required this.title,
    required this.markdownUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: CIColors.canvasBGColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Dialog.fullscreen(
        child: Material(
          color: CIColors.canvasBGColor,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: CIColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
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
                        'Remote help documents are disabled in this standalone TEST build.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: CIColors.textColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}