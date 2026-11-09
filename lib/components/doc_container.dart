
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/api_provider.dart';
import '../providers/overlay_controller.dart';
import '../services/api_service.dart';

class DocContainer extends StatefulWidget {
  final String label;
  final String link;

  const DocContainer({
    required this.label,
    this.link = "",
    super.key,
  });

  @override
  State<DocContainer> createState() => _DocContainerState();
}

class _DocContainerState extends State<DocContainer> {
  bool _isFetchFileLoading = false;

  Future<void> _showPdf(String fileName, BuildContext context) async {
    setState(() {
      _isFetchFileLoading = true;
    });

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final pdfData = await ApiService.fetchPdfBytes(
      'file&&filename=$fileName',
      token: apiProvider.authToken,
    );
    if (pdfData != null) {
      if (context.mounted) {
        final overlayProvider = Provider.of<OverlayProvider>(context, listen: false);
        overlayProvider.docViewerName = fileName;
        overlayProvider.docViewerLink = pdfData;
        overlayProvider.showDocViewerOverlay();
      }
    } else {
      // failed
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Error fetching file content.',
            style: TextStyle(
              color: CIColors.errorColor,
            ),
          ),
          backgroundColor: CIColors.errorBox,
        ));
      }
    }
    setState(() {
      _isFetchFileLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.label.toLowerCase().trim().endsWith('.pdf')) {
          _showPdf(widget.label, context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: CustomPaint(
          painter: DashedBorderPainter(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0x6CF6F9FD),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 0,
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                        color: Color(0xff009688),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                if (_isFetchFileLoading)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CupertinoActivityIndicator(),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CIColors.detaiBorderColor // Color of the dashed border
      ..strokeWidth = 1.0 // Width of the border
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0; // Width of each dash
    const dashSpace = 5.0; // Space between dashes
    const radius = 8.0; // Match the border radius of the container

    // Create a rounded rectangle path
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    // Draw dashed border along the rounded path
    _drawDashedPath(canvas, paint, path, dashWidth, dashSpace);
  }

  void _drawDashedPath(Canvas canvas, Paint paint, Path path, double dashWidth,
      double dashSpace) {
    final metrics = path.computeMetrics().first;
    double distance = 0;
    final totalLength = metrics.length;

    while (distance < totalLength) {
      final extract = metrics.extractPath(distance, distance + dashWidth);
      canvas.drawPath(extract, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
