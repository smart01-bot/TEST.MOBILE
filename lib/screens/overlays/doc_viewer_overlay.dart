
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../constants/colors.dart';
import '../../providers/overlay_controller.dart';

class DocViewerOverlay extends StatelessWidget {
  const DocViewerOverlay({super.key});


  @override
  Widget build(BuildContext context) {
    final overlayController = Provider.of<OverlayProvider>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: overlayController.isShownDocViewerOverlay,
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
                            overlayController.docViewerName,
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
                            overlayController.hideDocViewerOverlay();
                            overlayController.docViewerName = '';
                            overlayController.docViewerLink = null;
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
                      child: SfPdfViewerTheme(
                        data: SfPdfViewerThemeData(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          scrollHeadStyle: PdfScrollHeadStyle(
                            backgroundColor: CIColors.secondaryColor,
                            pageNumberTextStyle: TextStyle(
                              color: CIColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        child: SfPdfViewer.memory(overlayController.docViewerLink!),
                      ),
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
