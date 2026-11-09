import 'package:test_mobile/components/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../helpers/get_markdown_stylesheet.dart';

class FullScreenMarkdownDialog extends StatelessWidget {
  final String title;
  final String markdownUrl;

  const FullScreenMarkdownDialog({
    super.key,
    required this.title,
    required this.markdownUrl,
  });

  Future<String> fetchMarkdown() async {
    final response = await http.get(Uri.parse(markdownUrl));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load markdown');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: CIColors.canvasBGColor, // Sets the background color
        statusBarIconBrightness:
            Brightness.dark, // Use dark icons if bg is light
        statusBarBrightness: Brightness.light, // iOS status bar behavior
      ),
      child: Dialog.fullscreen(
          child: Material(
        color: CIColors.canvasBGColor,
        child: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: CIColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: CIColors.primaryColor,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: CIColors.whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FutureBuilder<String>(
                      future: fetchMarkdown(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: LoadingScreen(
                                  description: "Fetching content"));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Markdown(
                            data: snapshot.data ?? '',
                            styleSheet: getCustomMarkdownStyle(context),
                            onTapLink: (text, href, title) {
                              if (href != null) {
                                launchUrl(
                                  Uri.parse(href),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          // =========

          ),
    );
  }
}
