
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/colors.dart';
import '../../providers/overlay_controller.dart';

class WebViewerOverlay extends StatefulWidget {
  const WebViewerOverlay({super.key});

  @override
  State<WebViewerOverlay> createState() => _WebViewerOverlayState();
}

class _WebViewerOverlayState extends State<WebViewerOverlay> {
  final String link = 'https://flutter.dev';

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    final overlayController = Provider.of<OverlayProvider>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: overlayController.isShownWebViewerOverlay,
      builder: (context, isVisible, _) {
        if (!isVisible) return SizedBox.shrink();

        return Positioned.fill(
          child: Material(
            color: CIColors.canvasBGColor,
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
                            overlayController.webViewerName,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Color(0xff009688),
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
                            overlayController.hideWebViewerOverlay();
                            overlayController.webViewerName = '';
                            overlayController.webViewerLink = '';
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
                      child: WebViewWidget(controller: _controller),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
